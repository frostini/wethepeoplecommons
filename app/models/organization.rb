class Organization < ActiveRecord::Base
  has_many :requests, inverse_of: :organization

  validates_presence_of :name
  validates_presence_of :url

end
