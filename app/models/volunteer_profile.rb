class VolunteerProfile < ActiveRecord::Base
  has_many :skill_joins, as: :skillable
  has_many :skills, through: :skill_joins
  belongs_to :user, inverse_of: :volunteer_profile

  validates_presence_of :bio
  validates_presence_of :interest
end
