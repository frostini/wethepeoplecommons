class User < ActiveRecord::Base
  include ApplicationHelper
  has_secure_password

  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates_uniqueness_of :email
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name

  validates_format_of :phone, with: /\(?(\d{3})\)?[ .-]?(\d{3})[ .-]?(\d{4})\z/, message: 'is an invalid format.', allow_blank: true
  before_save   :sanitize_phone_field


  private

  def sanitize_phone_field
    self.phone = sanitize_phone_number(phone) if phone.present? && phone_changed?
  end
end
