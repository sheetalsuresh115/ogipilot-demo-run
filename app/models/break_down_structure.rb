class BreakDownStructure < ApplicationRecord

  validates :uuid, presence: true
  validates :from_uuid, presence: true
  validates :to_uuid, presence: true
  validates :short_name, presence: false
  belongs_to :functional_location, optional: true

end
