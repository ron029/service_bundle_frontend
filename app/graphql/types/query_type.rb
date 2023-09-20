module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :time_slot_by_service, resolver: Queries::TimeSlotByService
    field :service_admin, resolver: Queries::AdminService
    field :all_booking, resolver: Queries::AllBooking
    field :total_registration, resolver: Queries::TotalRegistrations
    field :admin_cart_item_count_service, resolver: Queries::AdminCartItemCountService
    field :service, resolver: Queries::Services
    field :service_category, resolver: Queries::ServiceCategories
    field :cart_items, resolver: Queries::CartItems
    field :carts, resolver: Queries::Carts
    field :cart_find, resolver: Queries::CartFind
    field :cart_history, resolver: Queries::CartHistories
    field :cart_item_category, resolver: Queries::CartItemCategory
    field :admin_cart_item, resolver: Queries::AdminCartItem
    field :admin_cart_item_category, resolver: Queries::AdminCartItemCategory
    field :logout, resolver: Queries::Logout
    field :booking_details, [Types::Models::BookingDetailType], null: false, description: 'Retrieve booking details'
    field :categories, [Types::Models::ServiceCategoryType], null: false
    field :time_slot, resolver: Queries::TimeSlot
    field :time_slot_one, resolver: Queries::TimeSlotOne
    field :service_by_category, resolver: Queries::ServiceByCategory
    field :cart_for_user, resolver: Queries::CartForUser

    def categories
      result = ServiceCategory.all

      Array.wrap(result)
    end

    def booking_details
      sql = "SELECT
      CONCAT(users.first_name, ' ', users.last_name) AS name_of_customer,
      services.name AS services,
      cart_items.date AS date, -- Assuming this is the cart_items date
      cart_items.time AS time,
      service_categories.name AS service_categories,
      services.price AS amount,
      cart_items.status AS status,
      carts.id AS booking_id,
      cart_items.id AS id,
      cart_histories.updated_at AS cart_date -- Assuming this is the cart_histories created_at
  FROM
      cart_items
  JOIN
      services ON cart_items.service_id = services.id
  JOIN
      carts ON cart_items.cart_id = carts.id
  JOIN
      users ON carts.user_id = users.id
  JOIN
      service_categories ON services.service_category_id = service_categories.id
  JOIN
      cart_histories ON carts.id = cart_histories.cart_id"
      ActiveRecord::Base.connection.execute(sql)
    end
    # TODO: remove me
    field :test_field, String, null: false, description: 'An example field added by the generator'
    def test_field
      'Hello World!'
    end
  end
end
