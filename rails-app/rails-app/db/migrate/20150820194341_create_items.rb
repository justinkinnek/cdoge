class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.belongs_to :user, index: true
      t.datetime :created
      t.string   :itemName
      t.string   :itemDescription
      t.string   :category
      t.integer  :remadeCount, :null => false, :default => 0
      t.integer  :trovedCount, :null => false, :default => 0
      t.integer  :likesCount,  :null => false, :default => 0

      t.timestamps
    end
  end
end
