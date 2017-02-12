class User < ActiveRecord::Base
  include ApplicationHelper
  has_secure_password

  has_many :requests, inverse_of: :user
  has_one :volunteer_profile, inverse_of: :user
  belongs_to :visitor, inverse_of: :user

  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates_uniqueness_of :email
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name

  validates_format_of :phone, with: /\(?(\d{3})\)?[ .-]?(\d{3})[ .-]?(\d{4})\z/, message: 'is an invalid format.', allow_blank: true
  before_save   :sanitize_phone_field
  before_save   :prettify_name

  def name
    first_name.titleize + ' ' + last_name.titleize
  end

  private

  def sanitize_phone_field
    self.phone = sanitize_phone_number(phone) if phone.present? && phone_changed?
  end

  def prettify_name
    self.first_name = first_name.split(' ').titleize.join(' ')
    self.last_name = last_name.split(' ').titleize.join(' ')
  end
end
