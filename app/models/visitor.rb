class Visitor < ActiveRecord::Base
  has_one :user, inverse_of: :visitor
  
  VALID_VISITOR_TYPE = ["Requester", "Volunteer"].freeze

  validates :group, inclusion: {in: VALID_VISITOR_TYPE}
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates_uniqueness_of :email, scope: :group
end
