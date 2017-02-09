class Visitor < ActiveRecord::Base
  VALID_VISITOR_TYPE = ["Requester", "Volunteer"].freeze

  validates :type, inclusion: {in: VALID_VISITOR_TYPE}
end
