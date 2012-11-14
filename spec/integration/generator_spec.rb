require 'spec_helper'

describe BigintPk::Generators::InstallGenerator, :integration do
  before do
    in_directory( RailsDir ) do
      run 'rails generate bigint_pk:install' do |stdout, stderr|
        expect( stdout.read ).to_not include 'Could not find generator'
      end
    end
  end

  it 'creates a bigint_pk initializer' do
    expect( File.exists? "#{RailsDir}/config/initializers/bigint_pk.rb").to be_true
  end

  it 'creates a bigint_pk migration' do
    expect( Dir["#{RailsDir}/db/migrate/*change_keys_to_bigint.rb"].size ).to eq 1
  end

  context "when migrations are created after bigint-pk is installed" do
    before do
      in_directory ( RailsDir ) do
        run 'rails g migration test_migration_after'
        run 'rails g bigint_pk:install'
      end
    end

    it "creates migration files in the correct order" do
      Dir["#{RailsDir}/db/migrate/*rb"].sort.map do |migration_file|
        File.basename( migration_file ).gsub(/^\d+_/, '')
      end.should == %w[
        create_empires_and_rulers.rb
        change_keys_to_bigint.rb
        test_migration_after.rb
        change_keys_to_bigint.rb
      ]
    end
  end
end
