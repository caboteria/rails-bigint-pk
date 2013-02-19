class UpdateRulersAddFavouriteRuler < ActiveRecord::Migration
  def change
    change_table :rulers do |t|
      t.references :favourite_ruler
    end
  end
end
