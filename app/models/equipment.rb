class Equipment < ApplicationRecord
  validates :uuid, presence: true
  validates :id_in_source, presence: true
  validates :functional_location_id, presence: true
  validates :short_name, presence: true
  validates :segment_uuid, presence: true
  validates :site_id, presence: true
  validates :properties, presence: true
  validates :installed_at, presence: true
  validates :uninstalled_at, presence: true
  validates :category, presence: true
  validates :bod_content, presence: true

end
