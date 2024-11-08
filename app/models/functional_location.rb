class FunctionalLocation < ApplicationRecord
  validates :uuid, presence: true
  validates :id_in_source, presence: true
  validates :description, presence: true
  validates :short_name, presence: true
  validates :segment_type, presence: true
  validates :status_id, presence: true
  validates :alarm_id, presence: true
  validates :is_active, presence: true
  belongs_to :break_down_structure

  def assign_values_to_floc_from_sync_segments(segment_info, bds)
    self.id_in_source = segment_info[:infoSource][:uUID]
    self.description = segment_info[:shortName]
    self.short_name = segment_info[:shortName]
    self.segment_type = segment_info[:type][:uUID]
    self.status_id = segment_info[:presentLifecycleStatus][:uUID]
    self.alarm_id = segment_info[:presentLifecycleStatus][:uUID]
    self.is_active = true
    self.break_down_structure = bds
  end

end
