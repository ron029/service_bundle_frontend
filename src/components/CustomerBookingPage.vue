<template>
  <div class="container">
    <div class="service_category_header">
      <h2 class="service_category_title">My <span class="service_category_title_name">Bookings</span></h2>
      <div class="btn-group booking_option" role="group" aria-label="Navigation">
        <input type="radio" class="btn-check" name="nav" id="all-tab" autocomplete="off" checked>
        <label class="btn btn-outline-primary" for="all-tab">All</label>
        <!-- <input type="radio" class="btn-check" name="nav" id="pending-tab" autocomplete="off">
        <label class="btn btn-outline-primary" for="pending-tab">Pending</label> -->
        <input type="radio" class="btn-check" name="nav" id="upcoming-tab" autocomplete="off">
        <label class="btn btn-outline-primary" for="upcoming-tab">Upcoming</label>
        <input type="radio" class="btn-check" name="nav" id="completed-tab" autocomplete="off">
        <label class="btn btn-outline-primary" for="completed-tab">Completed</label>
        <input type="radio" class="btn-check" name="nav" id="cancelled-tab" autocomplete="off">
        <label class="btn btn-outline-primary" for="cancelled-tab">Cancelled</label>
      </div>
    </div>
    <div class="tab-content" id="myTabContent">
      <!-- Content for each radio button goes here -->
      <div class="tab-pane fade show active" id="all-tab-pane" role="tabpanel" aria-labelledby="all-tab">
        <table class="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>No.</th>
              <th>Service Name</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody v-if="this.all.length > 0">
            <tr v-for="(item, index) in this.all" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ item.service.name }}</td>
              <td>{{ formatDate(item.date) }}</td>
              <td>{{ convertTimeToAMPM(item.time) }}</td>
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
              <td colspan="5">There is nothing to show in this table.</td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- <div class="tab-pane fade show" id="pending-tab-pane" role="tabpanel" aria-labelledby="pending-tab">
        <table class="table">
          <thead>
            <tr>
              <th>Service Name</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in this.pending" :key="index">
              <td>{{ item.service.name }}</td>
              <td>{{ item.date }}</td>
              <td>{{ item.time }}</td>
              <td class="no-wrap booking_status">
                <svg :class="item.status" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-circle-fill" viewBox="0 0 13 13">
                  <circle cx="8" cy="5" r="5"/>
                </svg>
                {{ item.status }}
              </td>
            </tr>
          </tbody>
        </table>
      </div> -->
      <div class="tab-pane fade" id="upcoming-tab-pane" role="tabpanel" aria-labelledby="upcoming-tab">
        <table class="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>No.</th>
              <th>Service Name</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody v-if="this.paid.length > 0">
            <tr v-for="(item, index) in this.paid" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ item.service.name }}</td>
              <td>{{ formatDate(item.date) }}</td>
              <td>{{ convertTimeToAMPM(item.time) }}</td>
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
              <td colspan="5">There is nothing to show in this table.</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade" id="completed-tab-pane" role="tabpanel" aria-labelledby="completed-tab">
        <table class="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>No.</th>
              <th>Service Name</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody v-if="this.completed.length > 0">
            <tr v-for="(item, index) in this.completed" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ item.service.name }}</td>
              <td>{{ formatDate(item.date) }}</td>
              <td>{{ convertTimeToAMPM(item.time) }}</td>
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
              <td colspan="5">There is nothing to show in this table.</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade" id="cancelled-tab-pane" role="tabpanel" aria-labelledby="cancelled-tab">
        <table class="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>No.</th>
              <th>Service Name</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody v-if="this.cancelled.length > 0">
            <tr v-for="(item, index) in this.cancelled" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ item.service.name }}</td>
              <td>{{ formatDate(item.date) }}</td>
              <td>{{ convertTimeToAMPM(item.time) }}</td>
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
              <td colspan="5">There is nothing to show in this table.</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade" id="mostbook-tab-pane" role="tabpanel" aria-labelledby="mostbook-tab">
        <table class="table table-bordered table-striped table-hover">
          <thead>
            <tr>
              <th>No.</th>
              <th>Service Name</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody v-if="this.completed.length > 0">
            <tr v-for="(item, index) in this.completed" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ item.service.name }}</td>
              <td>{{ formatDate(item.date) }}</td>
              <td>{{ convertTimeToAMPM(item.time) }}</td>
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
              <td colspan="5">There is nothing to show in this table.</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerBooking',
  data() {
    return {
      all: '',
      pending: '',
      paid: '',
      confirmed: '',
      cancelled: '',
      completed: ''
    }
  },
  methods: {
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
    load_table() {
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
    async cart_item_category() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/CartItemCategoryCustomer.gql'),
        });
        console.log(response)
        this.all = response.data.all;
        this.pending = response.data.pending;
        this.paid = response.data.paid;
        this.confirmed = response.data.confirmed;
        this.cancelled = response.data.cancelled;
        this.completed = response.data.completed;
      } catch (error) { 
        console.error('Error creating like:', error);
      }
    },
  },
  mounted() {
    this.cart_item_category();
    this.load_table();
  }
}
</script>

<style>

</style>

