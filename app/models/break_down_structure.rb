class BreakDownStructure < ApplicationRecord
  validates :uuid, presence: true
  validates :from, presence: true
  validates :to, presence: true

end
