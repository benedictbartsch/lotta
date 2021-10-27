class Project < ApplicationRecord
    has_many :items
    belongs_to :workspace
end
