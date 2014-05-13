require 'spec_helper'
require 'generators/bigint_pk/templates/migration'

describe 'ChangeKeysToBigint' do
  let(:connection) do
    double('Connection').tap do |c|
      c.stub(:quote_table_name){|tn| "`#{tn}`"}
      c.stub(:quote_column_name){|column| "`#{column}`"}
      c.stub(:table_exists?) { true }
      c.stub(:execute){|sql| queries << sql }
      c.stub(:column_exists?) do |table_name, column_name|
        if table_name.to_s == 'coaches' && column_name == 'team_id'
          false
        else
          true
        end
      end
    end
  end
  let(:queries){ [] }

  before do
    stub_const('Team', double('Team', table_name: 'teams', primary_key: 'id'))
    stub_const('Player', double('Player', table_name: 'players', primary_key: 'id'))
    stub_const('Coach', double('Coach', table_name: 'coaches', primary_key: 'id'))
    Team.stub( reflect_on_all_associations: [])
    Player.stub( reflect_on_all_associations: [
      double('belongs_to', macro: :belongs_to, foreign_key: 'team_id')])
    Coach.stub( reflect_on_all_associations: [
      double('belongs_to', macro: :belongs_to, foreign_key: 'team_id')])

    stub_const('Rails', double('Rails'))
    Rails.stub_chain 'application.eager_load!'
    Rails.stub(env: double('test', to_s: 'test', :'test?' => true, :'production?' => false, :'development?' => false))

    ActiveRecord::Base.stub( subclasses: [ Team, Player, Coach ], connection: connection)
    ActiveRecord::Base.stub_chain('connection_pool.with_connection') do |&prok|
      prok.call connection
    end
  end

  context 'with a postgres database' do
    before { connection.stub( adapter_name: 'PostgreSQL') }

    it 'migrates primary keys' do
      ChangeKeysToBigint.migrate :up
      expect( queries ).to include(
        'ALTER TABLE `teams` ALTER COLUMN `id` TYPE bigint',
        'ALTER TABLE `players` ALTER COLUMN `id` TYPE bigint',
        'ALTER TABLE `coaches` ALTER COLUMN `id` TYPE bigint'
      )
    end

    it 'migrates foreign keys' do
      ChangeKeysToBigint.migrate :up
      expect( queries ).to include(
        'ALTER TABLE `players` ALTER COLUMN `team_id` TYPE bigint'
      )
    end

    it 'does not migrate foreign keys that do not exist in database' do
      ChangeKeysToBigint.migrate :up
      expect( queries ).to_not include(
        'ALTER TABLE `coaches` ALTER COLUMN `team_id` TYPE bigint'
      )
    end
  end

  context 'with a mysql database' do
    before { connection.stub( adapter_name: 'MySQL') }

    it 'migrates primary keys' do
      ChangeKeysToBigint.migrate :up
      expect( queries ).to include(
        'ALTER TABLE `teams` MODIFY COLUMN `id` bigint(20) auto_increment',
        'ALTER TABLE `players` MODIFY COLUMN `id` bigint(20) auto_increment',
        'ALTER TABLE `coaches` MODIFY COLUMN `id` bigint(20) auto_increment'
      )
    end

    it 'migrates foreign keys' do
      ChangeKeysToBigint.migrate :up
      expect( queries ).to include(
        'ALTER TABLE `players` MODIFY COLUMN `team_id` bigint(20) DEFAULT NULL')
    end

    it 'does not migrate foreign keys that do not exist in database' do
      ChangeKeysToBigint.migrate :up
      expect( queries ).to_not include(
        'ALTER TABLE `coaches` MODIFY COLUMN `team_id` bigint(20) DEFAULT NULL'
      )
    end
  end

  context 'with a sqlite database' do
    before { connection.stub( adapter_name: 'SQLite') }

    it 'does not migrate any keys' do
      ChangeKeysToBigint.migrate :up
      expect( queries ).to eq []
    end
  end
end
