# This file is auto-generated when running `rails generate bigint_pk:install`
# by the gem rails-bigint-pk (https://github.com/VerticalResponse/rails-bigint-pk).

class ChangeKeysToBigint < ActiveRecord::Migration
  def change
    Rails.application.eager_load!
    ActiveRecord::Base.subclasses.select do |type|
      connection.table_exists? type.table_name
    end.each do |type|
      BigintPk.update_primary_key type.table_name, type.primary_key

      type.reflect_on_all_associations.select do |association|
        ( association.macro == :belongs_to ) &&
          connection.column_exists?( type.table_name, association.foreign_key )
      end.each do |belongs_to_association|
        BigintPk.update_foreign_key type.table_name, belongs_to_association.foreign_key
      end
    end
  end
end
