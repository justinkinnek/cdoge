class AddShippingZoneIdToStateAndCountry < ActiveRecord::Migration
  def change
    add_column :states,    :shipping_zone_id, :integer, :null => false
    add_column :countries, :shipping_zone_id, :integer
    add_index  :countries, [:shipping_zone_id, :active]
  end
end
