class ShippingZone < ActiveRecord::Base
  has_many :states
  USA48         = 'USA'
  ALASKA_HAWAII = 'Alaska and Hawaii'
  CANADA        = 'Canada'
  USA_TERRITORY = 'USA Territory'
  LOCATIONS     = [USA48, ALASKA_HAWAII, CANADA, USA_TERRITORY]
  validates :name, presence: true, length: { maximum: 255 }
  accepts_nested_attributes_for :states
end
