class User < ActiveRecord::Base
  include Concerns::UserImagesConcern
  has_many    :phones,                    dependent: :destroy,                               as: :phoneable
  has_one     :primary_phone,             -> { where(primary: true) },                       as: :phoneable,      class_name: 'Phone'
  has_many    :addresses,                 dependent: :destroy,                               as: :addressable
  has_one     :default_billing_address,   -> { where(billing_default: true, active: true) }, as: :addressable,    class_name: 'Address'
  has_many    :billing_addresses,         -> { where(active: true) },                        as: :addressable,    class_name: 'Address'
  has_one     :default_shipping_address,  -> { where(default: true, active: true) },         as: :addressable,    class_name: 'Address'
  has_many    :shipping_addresses,        -> { where(active: true) },                        as: :addressable,    class_name: 'Address'
  has_many    :items
  devise      :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :timeoutable, :lockable, :async
  
  has_many :authentications, dependent: :destroy, validate: false, inverse_of: :user do
    def grouped_with_oauth
      includes(:oauth_cache).group_by {|a| a.provider }
    end
  end
  
  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :phones, :reject_if => lambda { |t| ( t['display_number'].gsub(/\D+/, '').blank?) }
  after_create :send_welcome_emails

  def display_name
    first_name.presence || email.split('@')[0]
  end

  # Case insensitive email lookup.
  #
  # See Devise.config.case_insensitive_keys.
  # Devise does not automatically downcase email lookups.
  def self.find_by_email(email)
    find_by(email: email.downcase)
    # Use ILIKE if using PostgreSQL and Devise.config.case_insensitive_keys=[]
    #where('email ILIKE ?', email).first
  end

  # Override Devise to allow for Authentication or password.
  #
  # An invalid authentication is allowed for a new record since the record
  # needs to first be saved before the authentication.user_id can be set.
  def password_required?
    if authentications.empty?
      super || encrypted_password.blank?
    elsif new_record?
      false
    else
      super || encrypted_password.blank? && authentications.find{|a| a.valid?}.nil?
    end
  end

  # Merge attributes from Authentication if User attribute is blank.
  #
  # If User has fields that do not match the Authentication field name,
  # modify this method as needed.
  def reverse_merge_attributes_from_auth(auth)
    auth.oauth_data.each do |k, v|
      self[k] = v if self.respond_to?("#{k}=") && self[k].blank?
    end
  end

  # Do not require email confirmation to login or perform actions
  def confirmation_required?
    false
  end

  def send_welcome_emails
    UserMailer.delay.welcome_email(self.id)
    # UserMailer.delay_for(5.days).find_more_friends_email(self.id)
  end

  # Returns the default billing address if it exists.   otherwise returns the shipping address
  #
  # @param [none]
  # @return [ Address ]
  def billing_address
    default_billing_address ? default_billing_address : shipping_address
  end

  # Returns the default shipping address if it exists.   otherwise returns the first shipping address
  #
  # @param [none]
  # @return [ Address ]
  def shipping_address
    default_shipping_address ? default_shipping_address : shipping_addresses.first
  end

end
