class Phone < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to        :phone_type
  belongs_to        :phoneable,      polymorphic: true
  validates         :phone_type_id,  presence: true
  validates         :number,         presence: true,    numericality: { only_integer: true }, length:    { maximum: 25 }
  before_validation :sanitize_data
  after_save        :default_phone_check

  def display_number=(val)
    self.number = val
  end

  def display_number
    number_to_phone( self.number )
  end
  private

    def default_phone_check
        Phone.update_all(["phones.primary = ?", false],
                          ["phones.phoneable_id = ? AND phones.phoneable_type = ? AND id <> ?",
                            phoneable_id, phoneable_type, id]) if self.primary
    end

    def sanitize_data
      #  remove non-digits
      self.number = self.number.gsub!(/\W+/, '') if number
    end

end