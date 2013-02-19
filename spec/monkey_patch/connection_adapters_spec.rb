require 'spec_helper'
require 'active_record/connection_adapters/postgresql_adapter'
require 'active_record/connection_adapters/abstract_mysql_adapter'

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
        ).to eq 'bigint(20) DEFAULT NULL auto_increment PRIMARY KEY'
      end

      describe ActiveRecord::ConnectionAdapters::TableDefinition do
        describe '#references' do
          before do
            ActiveRecord::ConnectionAdapters::TableDefinition.
              any_instance.stub :references_without_default_bigint_fk

            @table_definition = ActiveRecord::ConnectionAdapters::TableDefinition.new Object.new
          end


          let(:args){ ['some_other_table', options ].compact }

          context 'when a limit is specified' do
            let(:options){{ limit: 6 }}

            it 'uses the specified limit' do
              @table_definition.should_receive(:references_without_default_bigint_fk).with(
                'some_other_table', hash_including( limit: 6 )
              )
              @table_definition.references *args
            end
          end

          context 'when a limit is not specified' do
            let(:options){}

            it 'defaults the limit to 8' do
              @table_definition.should_receive(:references_without_default_bigint_fk).with(
                'some_other_table', hash_including( limit: 8 )
              )
              @table_definition.references *args
            end
          end

          context 'when reference is polymorphic' do
            context 'when there is not additional options' do
              let(:options){{ polymorphic: true }}

              it 'should not contain limit' do
                @table_definition.should_receive(:references_without_default_bigint_fk).with(
                  'some_other_table', hash_including( polymorphic: {} )
                )
                @table_definition.references *args
              end
            end

            context 'when there is common options' do
              let(:options){{ null: false, polymorphic: true }}

              it "should contain common options" do
                @table_definition.should_receive(:references_without_default_bigint_fk).with(
                  'some_other_table', hash_including( polymorphic: { null: false } )
                )
                @table_definition.references *args
              end
            end

            context "when there is polymorphic options" do
              let(:options){{ null: false, polymorphic: { limit: 120 } }}

              it "should contain polymorphic options" do
                @table_definition.should_receive(:references_without_default_bigint_fk).with(
                  'some_other_table', hash_including( polymorphic: { limit: 120 } )
                )
                @table_definition.references *args
              end
            end
          end
        end
      end
    end

    context 'when not enabled' do
      let(:prok){ lambda{|c| c.enabled = false }}

      it 'does not alter the default primary key for the postgres adapter' do
        expect(
          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::
            NATIVE_DATABASE_TYPES[:primary_key]
        ).to eq 'serial primary key'
      end

      it 'does not alter the default primary key for either mysql adapters' do
        expect(
          ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::
            NATIVE_DATABASE_TYPES[:primary_key]
        ).to eq 'int(11) DEFAULT NULL auto_increment PRIMARY KEY'
      end
    end
  end
end
