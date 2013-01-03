# This file is auto-generated when running `rails generate bigint_pk:install`
# by the gem rails-bigint-pk (https://github.com/VerticalResponse/rails-bigint-pk).

class ChangeKeysToBigint < ActiveRecord::Migration
  def change
    Rails.application.eager_load!
    ActiveRecord::Base.subclasses.each do |type|
      if connection.table_exists? type.table_name
        BigintPk.update_primary_key type.table_name, type.primary_key
      end

      type.reflect_on_all_associations.select do |association|
        association.macro == :belongs_to
      end.each do |belongs_to_association|
        if connection.table_exists? type.table_name
          BigintPk.update_foreign_key type.table_name, belongs_to_association.foreign_key
        end
      end
    end
  end
end
