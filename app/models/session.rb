class Session < ApplicationRecord
  validates :end_point, presence: true
  validates :channel, presence: true
  validates :topic, presence: true
  validates :message_type, presence: true
end
