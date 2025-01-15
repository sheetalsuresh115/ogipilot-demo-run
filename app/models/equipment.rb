class Equipment < ApplicationRecord
  validates :uuid, presence: true
  validates :id_in_source, presence: true
  validates :functional_location_id, presence: true
  validates :short_name, presence: true
  validates :segment_uuid, presence: true
  validates :status_id, presence: true
  validates :alarm_id, presence: true
end
