class Request < ActiveRecord::Base
  has_many :skill_joins, as: :skillable
  has_many :skills, through: :skill_joins

  VALID_URGENCY_LEVEL = ["ASAP", "Soon", "Eventually"].freeze

  validates :urgency, inclusion: {in: VALID_URGENCY_LEVEL}
  validates_presence_of :description
  validates_presence_of :purpose

end