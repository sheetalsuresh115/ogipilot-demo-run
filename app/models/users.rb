class Users < ApplicationRecord
  has_secure_password
  # user_id here could be Employee Number
  validates :user_id, presence: true
  validates :user_name, presence: true
  validates :password, presence: true
  validates :name, presence: true
  validates :user_role, presence: true
end
