<template>
  <div>
    <div class="service_category_header">
      <h2 class="service_category_title">Manage <span class="service_category_title_name">Bookings</span></h2>
      <div class="btn-group booking_option" role="group" aria-label="Navigation">
        <input type="radio" class="btn-check" name="nav" id="all-tab" autocomplete="off" checked>
        <label class="btn btn-outline-primary" for="all-tab">All</label>
        <input type="radio" class="btn-check" name="nav" id="upcoming-tab" autocomplete="off">
        <label class="btn btn-outline-primary" for="upcoming-tab">Upcoming</label>
        <input type="radio" class="btn-check" name="nav" id="completed-tab" autocomplete="off">
        <label class="btn btn-outline-primary" for="completed-tab">Completed</label>
        <input type="radio" class="btn-check" name="nav" id="cancelled-tab" autocomplete="off">
        <label class="btn btn-outline-primary" for="cancelled-tab">Cancelled</label>
        <input type="radio" class="btn-check" name="nav" id="mostbook-tab" autocomplete="off">
        <label class="btn btn-outline-primary" for="mostbook-tab">Most Booked</label>
      </div>
    </div>
    <div class="tab-content" id="myTabContent">
      <!-- Content for each radio button goes here -->
      <div class="tab-pane fade show active table-responsive" id="all-tab-pane" role="tabpanel" aria-labelledby="all-tab">
        <table class="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>No.</th>
              <th class="no-wrap">Transaction ID</th>
              <th class="no-wrap">Reservation ID</th>
              <th class="no-wrap">Service Name</th>
              <th class="no-wrap">Registered Name</th>
              <th class="no-wrap">Checkout Name</th>
              <th>Date</th>
              <th>Time</th>
              <th>Price</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody v-if="all_booking.length > 0">
            <tr v-for="(item, index) in all_booking" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ convertToNewTransID(item.cart.id) }}</td>
              <td>{{ convertToNewID(item.id) }}</td>
              <td>{{ item.service.name }}</td>
              <td>{{ item.user.firstName }} {{ item.user.lastName }}</td>
              <td>{{ item.cartHistory.firstName }} {{ item.cartHistory.lastName }}</td>
              <td class="no-wrap">{{ formatDate(item.date) }}</td>
              <td class="no-wrap">{{ convertTimeToAMPM(item.time) }}</td>
              <td class="no-wrap">{{ formatToPHP(item.service.price) }}</td>
              <td class="no-wrap booking_status">
                <svg :class="item.status" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-circle-fill" viewBox="0 0 13 13">
                  <circle cx="8" cy="5" r="5"/>
                </svg>
                {{ item.status }}
              </td>
            </tr>
          </tbody>
          <tbody v-else>
            <tr>
              <td colspan="10">There is nothing to show in this table.</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade table-responsive table-container" id="upcoming-tab-pane" role="tabpanel" aria-labelledby="upcoming-tab">
        <table class="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>No.</th>
              <th class="no-wrap">Transaction ID</th>
              <th class="no-wrap">Reservation ID</th>
              <th class="no-wrap">Service Name</th>
              <th class="no-wrap">Registered Name</th>
              <th class="no-wrap">Checkout Name</th>
              <th>Date</th>
              <th>Time</th>
              <th>Price</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody v-if="paid.length > 0">
            <tr v-for="(item, index) in paid" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ convertToNewTransID(item.cart.id) }}</td>
              <td>{{ convertToNewID(item.id) }}</td>
              <td>{{ item.service.name }}</td>
              <td>{{ item.user.firstName }} {{ item.user.lastName }}</td>
              <td>{{ item.cartHistory.firstName }} {{ item.cartHistory.lastName }}</td>
              <td class="no-wrap">{{ formatDate(item.date) }}</td>
              <td class="no-wrap">{{ convertTimeToAMPM(item.time) }}</td>
              <td class="no-wrap">{{ formatToPHP(item.service.price) }}</td>
              <td class="no-wrap booking_status">
                <svg :class="item.status" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-circle-fill" viewBox="0 0 13 13">
                  <circle cx="8" cy="5" r="5"/>
                </svg>
                {{ item.status }}
              </td>
              <td class="no-wrap"> 
                <span @click="action_item(item, index, 'completed')" class="btn btn-success" title="Complete">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check2" viewBox="0 0 16 16">
                    <path d="M13.854 3.646a.5.5 0 0 1 0 .708l-7 7a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6.5 10.293l6.646-6.647a.5.5 0 0 1 .708 0z"/>
                  </svg>
                </span>
                <span @click="action_item(item, index, 'cancelled')" class="btn btn-danger" title="Cancel">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-ban" viewBox="0 0 16 16">
                    <path d="M15 8a6.973 6.973 0 0 0-1.71-4.584l-9.874 9.875A7 7 0 0 0 15 8ZM2.71 12.584l9.874-9.875a7 7 0 0 0-9.874 9.874ZM16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0Z"/>
                  </svg>
                </span>
              </td>
            </tr>
          </tbody>
          <tbody v-else>
            <tr>
              <td colspan="11">There is nothing to show in this table.</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade table-responsive" id="completed-tab-pane" role="tabpanel" aria-labelledby="completed-tab">
        <table class="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>No.</th>
              <th class="no-wrap">Transaction ID</th>
              <th class="no-wrap">Reservation ID</th>
              <th class="no-wrap">Service Name</th>
              <th class="no-wrap">Registered Name</th>
              <th class="no-wrap">Checkout Name</th>
              <th>Date</th>
              <th>Time</th>
              <th>Price</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody v-if="completed.length > 0">
            <tr v-for="(item, index) in completed" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ convertToNewTransID(item.cart.id) }}</td>
              <td>{{ convertToNewID(item.id) }}</td>
              <td>{{ item.service.name }}</td>
              <td>{{ item.user.firstName }} {{ item.user.lastName }}</td>
              <td>{{ item.cartHistory.firstName }} {{ item.cartHistory.lastName }}</td>
              <td class="no-wrap">{{ formatDate(item.date) }}</td>
              <td class="no-wrap">{{ convertTimeToAMPM(item.time) }}</td>
              <td class="no-wrap">{{ formatToPHP(item.service.price) }}</td>
              <td class="no-wrap booking_status">
                <svg :class="item.status" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-circle-fill" viewBox="0 0 13 13">
                  <circle cx="8" cy="5" r="5"/>
                </svg>
                {{ item.status }}
              </td>
            </tr>
          </tbody>
          <tbody v-else>
            <tr>
              <td colspan="10">There is nothing to show in this table.</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade table-responsive" id="cancelled-tab-pane" role="tabpanel" aria-labelledby="cancelled-tab">
        <table class="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>No.</th>
              <th class="no-wrap">Transaction ID</th>
              <th class="no-wrap">Reservation ID</th>
              <th class="no-wrap">Service Name</th>
              <th class="no-wrap">Registered Name</th>
              <th class="no-wrap">Checkout Name</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody v-if="cancelled.length > 0">
            <tr v-for="(item, index) in cancelled" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ convertToNewTransID(item.cart.id) }}</td>
              <td>{{ convertToNewID(item.id) }}</td>
              <td>{{ item.service.name }}</td>
              <td>{{ item.user.firstName }} {{ item.user.lastName }}</td>
              <td>{{ item.cartHistory.firstName }} {{ item.cartHistory.lastName }}</td>
              <td class="no-wrap">{{ formatDate(item.date) }}</td>
              <td class="no-wrap">{{ convertTimeToAMPM(item.time) }}</td>
              <td class="no-wrap booking_status">
                <svg :class="item.status" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-circle-fill" viewBox="0 0 13 13">
                  <circle cx="8" cy="5" r="5"/>
                </svg>
                {{ item.status }}
              </td>
            </tr>
          </tbody>
          <tbody v-else>
            <tr>
              <td colspan="9">There is nothing to show in this table.</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade table-responsive" id="mostbook-tab-pane" role="tabpanel" aria-labelledby="mostbook-tab">
        <table class="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>No.</th>
              <th>Count</th>
              <th>Service Name</th>
            </tr>
          </thead>
          <tbody v-if="most_booked.length > 0">
            <tr v-for="(item, index) in most_booked" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ item.count }}</td>
              <td>{{ item.service.name }}</td>
            </tr>
          </tbody>
          <tbody v-else>
            <tr>
              <td colspan="3">There is nothing to show in this table.</td>
            </tr>
          </tbody>
        </table> 
      </div>
    </div>
  </div>
</template>

<script>
import UPDATE_STATUS_ADMIN_CART_ITEM from '@/graphql/UpdateStatusAdminCartItem.gql';
import { mapState } from 'vuex';
export default {
  name: 'BookList',
  data(){
    return {
      most_booked: [],
      cancelled: [],
      upcoming: [],
      completed: [],
      paid: [],
      all_booking: [],
    }
  },
  computed: {
    ...mapState(['userRole']),
  },
  methods: {
    radio() {
      const radioButtons = document.querySelectorAll('.btn-check');
  const tabContents = document.querySelectorAll('.tab-pane');

  radioButtons.forEach((radioButton, index) => {
    radioButton.addEventListener('change', () => {
      tabContents.forEach((tabContent) => {
        tabContent.classList.remove('show', 'active');
      });
      tabContents[index].classList.add('show', 'active');
    });
  });
    }, 
    convertToNewTransID(id) {
      const prefix = '938'; // The common prefix for the new IDs
      const newID = prefix + id.toString().padStart(3, '0');
      return newID;
    },
    convertToNewID(id) {
      const prefix = '12321000'; // The common prefix for the new IDs
      const newID = prefix + id.toString().padStart(5, '0');
      return newID;
    },
    formatDate(inputDate) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      return new Date(inputDate).toLocaleDateString(undefined, options);
    },
    convertTimeToAMPM(timeString) {
      const dateTime = new Date(timeString);
      const hours = dateTime.getUTCHours();
      const minutes = dateTime.getUTCMinutes();
      const ampm = hours >= 12 ? 'PM' : 'AM';
      const formattedHours = hours % 12 || 12; // Convert 0 to 12 for 12-hour format

      const formattedTime = `${formattedHours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')} ${ampm}`;

      return formattedTime;
    },
    formatToPHP(number) {
      // Convert the number to a string with two decimal places
      const formattedNumber = Number(number).toFixed(2);

      // Add "PHP " to the formatted number and use commas as a thousands separator
      const result = `PHP ${formattedNumber.replace(/\B(?=(\d{3})+(?!\d))/g, ', ')}`;

      return result;
    },
    async admin_cart_item() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/AdminCartItemCategory.gql'),
        });
        this.all_booking = response.data.booking;
        this.pending = response.data.pending;
        this.confirmed = response.data.confirmed;
        this.cancelled = response.data.cancelled;
        this.completed = response.data.completed;
        this.paid = response.data.paid;
      } catch (error) {
        console.error('Error in create_cart_item:', error);
      }
    },  
    async admin_cart_item_count_service() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/AdminCartItemCountService.gql'),
        });
        this.most_booked = response.data.adminCartItemCountService;
      } catch (error) {
        console.error('Error in create_cart_item:', error);
      }
    },
    async action_item(item, index, action) {
      console.log(item, action)
      let status = 0;
      if (action == 'cancelled') { status = 3; }
      if (action == 'completed') { status = 4; } 
      const response = await this.$apollo.mutate({
        mutation: UPDATE_STATUS_ADMIN_CART_ITEM,
        variables: {
          id: parseInt(item.id),
          status: status
        }
      })
      if (response) {
        const data = this.paid.splice(index, 1)[0];
        console.log('booking to remove', data)
        console.log('add data to action: ', this.completed);
        if (action == 'cancelled') {
          data.status = 'cancelled'
          this.cancelled.unshift(data)
        } 
        if (action == 'completed') {
          data.status = 'completed'
          this.completed.unshift(data)
        }
        console.log('new action list: ', this.completed)
        alert('The Booking has been ' + action + '.' )
      }
      console.log(response)
    },
    reloadPage() {
      // Reload the current page
      window.location.reload();
    },
  },
  mounted() {
    this.radio();
    this.admin_cart_item();
    this.admin_cart_item_count_service();
  }
}
console.log('asdf')
</script>

<style>
/* Override Bootstrap table-hover styles with a more specific selector */
.table.table-hover tbody tr:hover > td {
  background-color: yellow !important;
  /* You can adjust the yellow color to your preferred shade */
  /* Example: background-color: #FFFF00; */
}

.btn-check:checked + label.btn-outline-primary {
    color: white;
}

.no-wrap {
  white-space: nowrap;
}

.booking_option {
  position: absolute;
  top: 20px;
  right: 20px;
  background-color: white;
}

.booking_status {
  text-align: left;
}

.completed {
  color: green;
}

.cancelled {
  color: red;
}

.pending {
  color: gray;
}
</style>