class TimeSlot < ApplicationRecord
  belongs_to :service

  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :start_time_validation

  validates_date :date, on_or_after: :today, on_or_after_message: 'must be today or a future date'
  validates_time :end_time, after: :start_time

  private

  def start_time_validation
    if date == Date.today && start_time.present?
      if start_time <= Time.now
        errors.add(:start_time, 'must be in the future')
      end
    end
  end
end
