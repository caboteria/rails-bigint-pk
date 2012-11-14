require 'rails/generators'

module BigintPk
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path '../templates', __FILE__

      desc 'Creates BigintPk initializer'


      def create_initializer_file
        template 'bigint_pk.rb', 'config/initializers/bigint_pk.rb'
      end

      def create_migration
        version = Time.now.utc.strftime '%Y%m%d%H%M%S'
        template "migration.rb", "db/migrate/#{version}_change_keys_to_bigint.rb"
      end
    end
  end
end
