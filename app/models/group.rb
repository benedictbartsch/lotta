class Group < ApplicationRecord
  acts_as_taggable_on :tags
  acts_as_taggable_tenant :workspace_id
  has_many :items
  belongs_to :workspace
  belongs_to :project, optional: true

  validates :name, presence: true
end
