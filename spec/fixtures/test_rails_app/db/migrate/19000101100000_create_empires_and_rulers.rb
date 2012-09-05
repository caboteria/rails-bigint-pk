class CreateEmpiresAndRulers < ActiveRecord::Migration
  def change
    create_table :empires do |t|
    end

    create_table :rulers do |t|
      t.references :empire
    end
  end
end
