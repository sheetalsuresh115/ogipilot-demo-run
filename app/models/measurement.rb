class Measurement < ApplicationRecord

  validates :time_stamp, presence: true
  validates :data, presence: true
  belongs_to :equipment

  def get_json_chart_values
    return { x: self.time_stamp, y: self.data }.to_json
  end

end
