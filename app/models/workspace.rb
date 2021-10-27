class Workspace < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :projects
  has_many :gutentag_tags
end
