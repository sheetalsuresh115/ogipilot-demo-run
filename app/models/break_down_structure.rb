class BreakDownStructure < ApplicationRecord

  validates :uuid, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :short_name, presence: false
  belongs_to :functional_location, optional: true

end
