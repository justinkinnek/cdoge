class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string  :name
      t.string  :abbreviation,       :limit => 5
      t.boolean :active,             :default => false
    end
    add_index :countries, :name
    add_index :countries, :active
  end

  def self.down
    drop_table :countries
  end
end
