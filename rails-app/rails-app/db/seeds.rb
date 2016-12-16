puts "SEEDING..."

puts "COUNTRIES"
file_to_load  = Rails.root + 'db/seed/countries.yml'
countries_list   = YAML::load( File.open( file_to_load ) )
countries_list.each_pair do |key,country|
  s = Country.find_by(abbreviation: country['abbreviation'])
  unless s
    c = Country.create(country) unless s
    c.update_attribute(:active, true) if Country::ACTIVE_COUNTRY_IDS.include?(c.id)
  end
end

puts "STATES"
file_to_load  = Rails.root + 'db/seed/states.yml'
states_list   = YAML::load( File.open( file_to_load ) )
states_list.each_pair do |key,state|
  s = State.find_by(abbreviation: state['attributes']['abbreviation'], country_id: state['attributes']['country_id'])
  State.create(state['attributes']) unless s
end

puts "Address Types"
AddressType::NAMES.each do |address_type|
  AddressType.find_or_create_by(name: address_type)
end

puts "PHONE TYPES"
PhoneType::NAMES.each do |phone_type|
  PhoneType.find_or_create_by(name: phone_type)
end

puts "SHIPPING RATE TYPES"
ShippingRateType::TYPES.each do |rate_type|
  ShippingRateType.find_or_create_by(name: rate_type)
end

puts "Shipping Zones"
ShippingZone::LOCATIONS.each do |loc|
  ShippingZone.where(name: loc ).first_or_create
end

puts "ITEMS"
file_to_load  = Rails.root + 'db/seed/items.yml'
items_list    = YAML::load( File.open( file_to_load ) )
items_list.each_pair do |key,item|
  Item.create(item['attributes'])
end