class Workspace < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :projects
  has_many :gutentag_tags
  has_many :groups

  validates :name, presence: true, length: { in: 2..20 }
end
