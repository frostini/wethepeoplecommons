class Skill < ActiveRecord::Base
  belongs_to :skillable, polymorphic: true
  has_many :skill_joins
end
