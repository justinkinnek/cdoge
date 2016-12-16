class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer  :address_type_id
      t.string   'first_name'
      t.string   'last_name'
      t.string   'addressable_type',    :null => false
      t.integer  'addressable_id',      :null => false
      t.string   'address1',            :null => false
      t.string   'address2'
      t.string   'city',                :null => false
      t.integer  'state_id'
      t.string   'state_name'
      t.string   'zip_code',            :null => false
      t.integer  'phone_id'
      t.string   'alternative_phone'
      t.boolean  'default',             :default => false
      t.boolean  'billing_default',     :default => false
      t.boolean  'active',              :default => true
      t.timestamps
    end
    add_index :addresses, :state_id
    add_index :addresses, :addressable_id
    add_index :addresses, :addressable_type
  end

  def self.down
    drop_table :addresses
  end
end
