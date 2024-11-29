class ActualEvent < ApplicationRecord

  validates :uuid, presence: true
  validates :group_uuid, presence: false
  validates :attribute_type, presence: true
  validates :value, presence: false
  validates :uom, presence: false
  belongs_to :functional_location, optional: true
end
