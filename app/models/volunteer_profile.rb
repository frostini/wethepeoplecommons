class VolunteerProfile < ActiveRecord::Base
  has_many :skill_joins, as: :skillable
  has_many :skills, through: :skill_joins
end
