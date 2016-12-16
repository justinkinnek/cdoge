class ShippingRateType < ActiveRecord::Base
  has_many :shipping_rates
  INDIVIDUAL  = 'Individual'
  ORDER       = 'Order'
  TYPES = [INDIVIDUAL, ORDER]
  INDIVIDUAL_ID  = 1
  ORDER_ID       = 2
end