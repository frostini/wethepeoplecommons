class Visitor < ActiveRecord::Base
  VALID_VISITOR_TYPE = ["Requester", "Volunteer"].freeze

  validates :group, inclusion: {in: VALID_VISITOR_TYPE}
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates_uniqueness_of :email, scope: :group
end
