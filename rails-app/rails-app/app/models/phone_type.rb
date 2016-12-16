class PhoneType < ActiveRecord::Base
  has_many  :phones
  validates :name,   presence: true,  length: { maximum: 25 }
  NAMES = ['Cell', 'Home', 'Work', 'Other']
end