class CreatePhoneTypes < ActiveRecord::Migration
  def change
    create_table :phone_types do |t|
      t.string  :name,  :null => false
    end
  end

  def self.down
    drop_table :phone_types
  end
end
