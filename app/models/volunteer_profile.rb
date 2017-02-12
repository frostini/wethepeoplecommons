class VolunteerProfile < ActiveRecord::Base
  has_many :skill_joins, as: :skillable
  has_many :skills, through: :skill_joins
  belongs_to :user, inverse_of: :volunteer_profile, dependent: :destroy

  validates_presence_of :bio
  validates_presence_of :interest

  def tags
    skills.map(&:tag).join(" ")
  end
end
