class CreateShippingCategories < ActiveRecord::Migration
  def change
    create_table :shipping_categories do |t|
      t.string     :name, :null => false,   :unique => true
    end
  end

  def self.down
    drop_table     :shipping_categories
  end
end
