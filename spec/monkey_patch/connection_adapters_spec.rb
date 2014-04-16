require 'spec_helper'
require 'active_record/connection_adapters/postgresql_adapter'
require 'active_record/connection_adapters/abstract_mysql_adapter'

MYSQL_DEFAULT_PK = ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES[:primary_key]
PG_DEFAULT_PK = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:primary_key]

describe BigintPk do
  describe '::setup' do
    def reset_connection_adapters!
      if defined? ::ActiveRecord::ConnectionAdapters
        [:PostgreSQLAdapter, :AbstractMysqlAdapter].each do |adapter|
          if ActiveRecord::ConnectionAdapters.const_defined? adapter
            ActiveRecord::ConnectionAdapters.send :remove_const, adapter
          end
        end
      end
      ActiveRecord::ConnectionHandling.send :remove_const, :VALID_CONN_PARAMS
      load 'active_record/connection_adapters/postgresql/referential_integrity.rb'
      load 'active_record/connection_adapters/postgresql_adapter.rb'
      load 'active_record/connection_adapters/abstract_mysql_adapter.rb'
    end

    before do
      ActiveRecord::Base.class_eval do
        def self.establish_connection; end
      end

      reset_connection_adapters!
      BigintPk.setup &prok
    end

    context 'when enabled' do
      let(:prok){ lambda{|c| c.enabled = true }}

      it 'updates the default primary key for the postgres adapter' do
        expect(
          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::
            NATIVE_DATABASE_TYPES[:primary_key]
        ).to eq 'bigserial primary key'
      end

      it 'updates the default primary key for both mysql adapters' do
        expect(
          ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::
            NATIVE_DATABASE_TYPES[:primary_key]
        ).to eq 'bigint(20) auto_increment PRIMARY KEY'
      end

      def self.it_makes_references_default_to_64bit
        describe '#references' do
          before { abstract_table_class.any_instance.stub :references_without_default_bigint_fk }


          let(:args){ ['some_other_table', options ].compact }

          context 'when a limit is specified' do
            let(:options){{ limit: 6 }}

            it 'uses the specified limit' do
              abstract_table.should_receive(:references_without_default_bigint_fk).with(
                'some_other_table', hash_including( limit: 6 )
              )
              abstract_table.references *args
            end
          end

          context 'when a limit is not specified' do
            let(:options){}

            it 'defaults the references limit to 8' do
              abstract_table.should_receive(:references_without_default_bigint_fk).with(
                'some_other_table', hash_including( limit: 8 )
              )
              abstract_table.references *args
            end

            it 'defaults the belongs_to limit to 8' do
              abstract_table.should_receive(:references_without_default_bigint_fk).with(
                'some_other_table', hash_including( limit: 8 )
              )
              abstract_table.belongs_to *args
            end
          end

          context 'when reference is polymorphic' do
            context 'when there is not additional options' do
              let(:options){{ polymorphic: true }}

              it 'should not contain limit' do
                abstract_table.should_receive(:references_without_default_bigint_fk).with(
                  'some_other_table', hash_including( polymorphic: {} )
                )
                abstract_table.references *args
              end
            end

            context 'when there is common options' do
              let(:options){{ null: false, polymorphic: true }}

              it "should contain common options" do
                abstract_table.should_receive(:references_without_default_bigint_fk).with(
                  'some_other_table', hash_including( polymorphic: { null: false } )
                )
                abstract_table.references *args
              end
            end

            context "when there is polymorphic options" do
              let(:options){{ null: false, polymorphic: { limit: 120 } }}

              it "should contain polymorphic options" do
                abstract_table.should_receive(:references_without_default_bigint_fk).with(
                  'some_other_table', hash_including( polymorphic: { limit: 120 } )
                )
                abstract_table.references *args
              end
            end
          end
        end
      end

      describe ActiveRecord::ConnectionAdapters::Table do
        let(:abstract_table_class){ ActiveRecord::ConnectionAdapters::TableDefinition }
        let(:abstract_table){ abstract_table_class.new({}, "table", {}, {}) }
        it_makes_references_default_to_64bit
      end

      describe ActiveRecord::ConnectionAdapters::TableDefinition do
        let(:connection_adapter_double) do
          double("Connection Adapter").tap do |double|
            double.stub :add_column
          end
        end
        let(:abstract_table_class){ ActiveRecord::ConnectionAdapters::Table }
        let(:abstract_table) do
          abstract_table_class.new 'test_table', connection_adapter_double
        end
        it_makes_references_default_to_64bit
      end
    end

    context 'when not enabled' do
      let(:prok){ lambda{|c| c.enabled = false }}

      it 'does not alter the default primary key for the postgres adapter' do
        expect(
          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::
            NATIVE_DATABASE_TYPES[:primary_key]
        ).to eq PG_DEFAULT_PK
      end

      it 'does not alter the default primary key for either mysql adapters' do
        expect(
          ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::
            NATIVE_DATABASE_TYPES[:primary_key]
        ).to eq MYSQL_DEFAULT_PK
      end
    end
  end
end
