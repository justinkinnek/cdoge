class Item < ActiveRecord::Base
  belongs_to :user
  before_create :set_created
  

  protected

  def set_created
     self.created = Time.now
  end
end
