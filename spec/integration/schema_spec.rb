require 'spec_helper'

describe 'Migrations', :integration do
  before :all do
    in_directory( RailsDir ){ run 'rails generate bigint_pk:install' }
  end

  describe 'create_table' do
    def self.they_use_bigint_primary_keys
      describe 'primary keys' do
        they 'default to 64bit' do
          expect{
            execute_sql %Q{
              insert into empires values(#{2 ** 31 - 1});
              insert into empires values(#{2 ** 31});
            }
          }.to_not raise_error

          expect(
            execute_ruby 'puts Empire.all.collect(&:id)'
          ).to eq ["#{2**31-1}", "#{2**31}"].join("\n")
        end
      end
    end

    def self.they_use_bigint_foreign_keys
      describe 'foreign keys' do
        they 'can reference 64bit values' do
          expect{
            execute_sql %Q{
              insert into empires values(#{2 ** 31 + 1});
              insert into empires values(#{2 ** 31 + 2});
              insert into rulers( empire_id ) values(#{2 ** 31 + 1});
              insert into rulers( empire_id ) values(#{2 ** 31 + 2});
            }
          }.to_not raise_error

          expect(
            execute_ruby 'puts Ruler.all.map{|r| r.empire.id}'
          ).to eq ["#{2**31 + 1}", "#{2**31 + 2}"].join("\n")
        end

        context 'that were added to an existing table' do
          they 'can reference 64bit values' do
            expect{
              execute_sql %Q{
                insert into rulers( id ) values(#{2 ** 31 + 1});
                insert into rulers( id ) values(#{2 ** 31 + 2});

                insert into rulers( favourite_ruler_id ) values(#{2 ** 31 + 1});
                insert into rulers( favourite_ruler_id ) values(#{2 ** 31 + 2});
              }
            }.to_not raise_error

            expect(
              execute_ruby('puts Ruler.all.map{|r| r.favourite_ruler_id}').split
            ).to eq ["#{2**31 + 1}", "#{2**31 + 2}"]
          end
        end
      end
    end

    context 'with a mysql database' do
      before(:all) do
        use_database! :mysql
        rake 'db:migrate'
      end

      they_use_bigint_primary_keys
      they_use_bigint_foreign_keys
    end

    context 'with a postgresql database' do
      before(:all) do
        use_database! :postgres
        rake 'db:migrate'
      end

      they_use_bigint_primary_keys
      they_use_bigint_foreign_keys
    end

    context 'with a sqlite3 database' do
      before(:all) do
        use_database! :sqlite3
        rake 'db:migrate'
      end

      they_use_bigint_primary_keys
      they_use_bigint_foreign_keys
    end
  end

  describe 'existing tables' do
    def self.they_have_their_primary_keys_migrated
      they 'have their primary keys migrated' do
        expect{
          execute_sql %Q{
            insert into empires values(#{2 ** 31 - 1});
            insert into empires values(#{2 ** 31});
          }
        }.to raise_error

        execute_ruby 'Empire.delete_all'
        rake 'db:migrate'

        expect{
          execute_sql %Q{
            insert into empires values(#{2 ** 31 - 1});
            insert into empires values(#{2 ** 31});
          }
        }.to_not raise_error
      end
    end

    def self.they_have_their_foreign_keys_migrated
      they 'have their foreign keys migrated' do
        expect{
          execute_sql %Q{
            insert into empires values(#{2 ** 31 - 1});
            insert into empires values(#{2 ** 31});
            insert into rulers( empire_id ) values(#{2 ** 31});
            insert into rulers( empire_id ) values(#{2 ** 31 - 1});
          }
        }.to raise_error

        execute_ruby 'Ruler.delete_all'
        execute_ruby 'Empire.delete_all'
        rake 'db:migrate'

        expect{
          execute_sql %Q{
            insert into empires values(#{2 ** 31 - 1});
            insert into empires values(#{2 ** 31});
            insert into rulers( empire_id ) values(#{2 ** 31 - 1});
            insert into rulers( empire_id ) values(#{2 ** 31});
          }
        }.to_not raise_error

        expect(
          execute_ruby 'puts Ruler.all.collect{|r| [r.id, r.empire.id]}'
        ).to eq [ "1", "#{2**31 - 1}",
                  "2", "#{2**31}"].join("\n")
      end
    end

    InitializerFile = "#{RailsDir}/config/initializers/bigint_pk.rb"

    before :each do
      initializer = File.read InitializerFile
      initializer.gsub!( /enabled = true/, 'enabled = false' )
      File.open( InitializerFile, 'w'){|f| f.print initializer }
    end


    context 'with a mysql database' do
      before(:each) do
        use_database! :mysql
        rake 'db:migrate VERSION=19000101100000'
      end

      they_have_their_primary_keys_migrated
      they_have_their_foreign_keys_migrated
    end

    context 'with a postgresql database' do
      before(:each) do
        use_database! :postgres
        rake 'db:migrate VERSION=19000101100000'
      end

      they_have_their_primary_keys_migrated
      they_have_their_foreign_keys_migrated
    end
  end

  describe "with models & migrations created after bigint migration" do
    before :all do
      in_directory( RailsDir ) { run 'rails g model subject' }
    end

    def self.it_completes_migration
      it "completes the migration" do
        in_directory( RailsDir ) do
          run("rake db:migrate")
        end
      end
    end
    
    context "with a mysql database" do
      before(:each) do
        use_database! :mysql
      end

      it_completes_migration
    end
    
    context "with a postgresql database" do
      before(:each) do
        use_database! :postgres
      end

      it_completes_migration
    end
  end
end
