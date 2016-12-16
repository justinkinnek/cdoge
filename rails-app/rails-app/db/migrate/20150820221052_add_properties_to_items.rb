class AddPropertiesToItems < ActiveRecord::Migration
  def change
    add_column :items, :shipping_category_id, :integer, :default => 1
    add_column :items, :meta_keywords,        :string
    add_column :items, :meta_description,     :string 
    add_column :items, :featured,             :boolean, :default => false
    add_index  :items, :itemName
    add_index  :items, :shipping_category_id
  end
end
