class FunctionalLocation < ApplicationRecord

  validates :uuid, presence: true
  validates :id_in_source, presence: false
  validates :description, presence: false
  validates :short_name, presence: true
  validates :segment_type, presence: false
  validates :status_id, presence: false
  validates :alarm_id, presence: false
  validates :is_active, presence: false
  validates :comments, presence: false
  belongs_to :break_down_structure, optional: true

  def assign_values_to_floc_from_sync_segments(segment_info, bds)
    self.id_in_source = segment_info.dig("infoSource","uUID")
    self.description = segment_info.dig("shortName")
    self.short_name = segment_info.dig("shortName")
    self.segment_type = segment_info.dig("type","uUID")
    self.status_id = segment_info.dig("presentLifecycleStatus","uUID")
    self.alarm_id = segment_info.dig("presentLifecycleStatus","uUID")
    self.is_active = true
    self.break_down_structure = bds
  end

  def create_functional_location_with_minimal_info(segment_info, comments='')
    self.short_name = segment_info.dig("shortName")
    self.segment_type = segment_info.dig("type")
    self.comments = comments
  end

end
