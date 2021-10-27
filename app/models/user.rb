class User < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: /\A[^@\s]+@[^@\s]+\z/

  passwordless_with :email

  has_many :workspaces
end
