class Measurement < ApplicationRecord
  belongs_to :equipment
  validates :time_stamp, presence: true
  validates :data, presence: true
end
