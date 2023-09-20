class CartItem < ApplicationRecord
  # before_save :validate_time_slot
  # before_save :check_time_slot_capacity

  belongs_to :cart
  belongs_to :service
  
  # validate :time_validation
  validates_date :date, on_or_after: :today, on_or_after_message: 'must be today or a future date'
  validates :status, :date, :time, presence: true

  enum status: { pending: 0, paid: 1, confirmed: 2, cancelled: 3, completed: 4 }

  def time_validation
    if date == Date.today && time.present?
      if time <= Time.now
        errors.add(:time, 'must be in the future')
      end
    end
  end

  def validate_time_slot
    return if service.blank? || date.blank? || time.blank?

    # Find the associated service's time slots for the specified date
    available_time_slots = service.time_slots.where(date: date)

    if available_time_slots.any?
      item_time = time # No need to convert, as it's already a Time object
      unless available_time_slots.any? { |slot| time_within_range?(slot.start_time, slot.end_time, item_time) }
        errors.add(:base, 'Selected time is not within any available time slot')

        # Raise an exception to prevent the record from being saved
        raise ActiveRecord::RecordInvalid.new(self)
      end
    else
      errors.add(:base, 'No available time slots for the selected date')

      # Raise an exception to prevent the record from being saved
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  def time_within_range?(start_time, end_time, item_time)
    item_time >= start_time && item_time <= end_time
  end

  def check_time_slot_capacity
    return if service.blank? || date.blank? || time.blank?

    # Find the associated service's time slot for the specified date
    time_slot = service.time_slots.find_by(date: date)

    if time_slot.blank?
      # No time slot found for the specified date, nothing to check, continue saving
      return
    end

    # Calculate the time range for the current cart_item using time_slot's start_time and end_time
    current_cart_item_range = time_slot.start_time..time_slot.end_time

    # Count the number of "paid", "completed", and "confirmed" cart_items with the same service, same date,
    # and overlapping time range
    overlapping_cart_items_count = CartItem
      .where(service_id: service.id, date: date, status: %w[paid completed confirmed])
      .where(time: current_cart_item_range)
      .count

    if (overlapping_cart_items_count + 1) > time_slot.capacity.to_i
      errors.add(:base, 'Time slot capacity is full')

      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  def fits_capacity?
    # Retrieve the associated service for this cart_item
    service = Service.find(service_id)
    return false unless service.present?

    # Retrieve all associated time_slots for the service on the specified date
    time_slots = service.time_slots.where(date: date)
    return false unless time_slots.present?

    # Count the number of cart_items within the time_slots
    cart_items_count = CartItem
      .joins(service: :time_slots)
      .where('services.id = ? AND time_slots.id IN (?)', service.id, time_slots.pluck(:id))
      .where(status: %w[paid completed confirmed])
      .count

    # Count the cart items with the same service_id and date
    service_time_slot = TimeSlot.where(service_id: service_id, date: date)

    cart_items_count < service_time_slot[0].capacity
  end

  def self.booking_details
    select(
      'cart_items.id AS "Booking number"',  # Using cart_item's ID as the booking number
      'cart_histories.date AS "Booking date"',
      'CONCAT(cart_histories.first_name, " ", cart_histories.last_name) AS "Name of customer"',
      'service_categories.name AS "Service category"',
      'cart_items.date AS "Date"',
      'cart_items.time AS "Time"',
      'services.name AS "Service"',
      'services.price AS "Amount"'
    )
    .joins(:cart, service: :service_category)
    .joins(cart: :cart_history)
  end
end
