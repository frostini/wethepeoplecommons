class SkillJoin < ActiveRecord::Base
  belongs_to :skillable, polymorphic: true, dependent: :destroy
  belongs_to :skill
  belongs_to :request, -> { where(skill_joins: {skillable_type: 'Request'})}, foreign_key: 'skillable_id'
  belongs_to :volunteer_profile, -> { where(skill_joins: {skillable_type: 'VolunteerProfile'})}, foreign_key: 'skillable_id'

  scope :requested, -> { where(skillable_type: "Request") }
  scope :volunteered, -> { where(skillable_type: "VolunteerProfile") }
end
