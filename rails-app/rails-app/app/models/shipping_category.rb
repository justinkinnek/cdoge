class ShippingCategory < ActiveRecord::Base
  has_many :items
  has_many :shipping_rates
  validates :name, presence: true, length: { maximum: 255 }
end
