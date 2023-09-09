<template>
  <div class="container">
    <h1>Booking History</h1>
    <ul class="nav nav-tabs" id="myTab" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active" id="home-tab" data-bs-toggle="tab" data-bs-target="#home-tab-pane" type="button" role="tab" aria-controls="home-tab-pane" aria-selected="true">Booking</button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile-tab-pane" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="false">Bookings History</button>
      </li>
    </ul>
    <div class="tab-content" id="myTabContent">
      <div class="tab-pane fade show active" id="home-tab-pane" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
        <table class="table">
          <thead>
            <tr>
              <td>id</td>
              <td>bookingId</td>
              <td>cartDate</td>
              <td>serviceCategories</td>
              <td>services</td>
              <td>nameOfCustomer</td>
              <td>date</td>
              <td>time</td>
              <td>amount</td>
              <td>status</td>
              <td>action</td>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in history" :key="item.id">
              <td>{{ item.id }}</td>
              <td>{{ item.bookingId }}</td>
              <td>{{ item.cartDate }}</td>
              <td>{{ item.serviceCategories }}</td>
              <td>{{ item.services }}</td>
              <td>{{ item.nameOfCustomer }}</td>
              <td>{{ item.date }}</td>
              <td>{{ item.time }}</td>
              <td>{{ item.amount }}</td>
              <td>{{ getStatusLabel(item) }}</td>
              <td>
                <span @click="action_item(item, 'COMPLETED')" class="btn btn-success">Completed</span>
                <span @click="action_item(item, 'CANCELLED')" class="btn btn-danger">Cancelled</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade show active" id="profile-tab-pane" role="tabpanel" aria-labelledby="profile-tab" tabindex="0">
        <table class="table">
          <thead>
            <tr>
              <td>id</td>
              <td>bookingId</td>
              <td>cartDate</td>
              <td>serviceCategories</td>
              <td>services</td>
              <td>nameOfCustomer</td>
              <td>date</td>
              <td>time</td>
              <td>amount</td>
              <td>status</td>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in history" :key="item.id">
              <td>{{ item.id }}</td>
              <td>{{ item.bookingId }}</td>
              <td>{{ item.cartDate }}</td>
              <td>{{ item.serviceCategories }}</td>
              <td>{{ item.services }}</td>
              <td>{{ item.nameOfCustomer }}</td>
              <td>{{ item.date }}</td>
              <td>{{ item.time }}</td>
              <td>{{ item.amount }}</td>
              <td>{{ getStatusLabel(item) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BookingManager',
  data(){
    return {
      history: []
    }
  },
  methods: {
    async action_item(item, action) {
      console.log(item, action)
      let status = 0;
      if (action == 'CANCELLED') status = 3
      if (action == 'COMPLETED') status = 4
      const response = await this.$apollo.mutate({
        mutation: require('@/graphql/UpdateStatusAdminCartItem.gql'),
        variables: {
          id: parseInt(item.id),
          status: status
        }
      })
      if (response) {
        alert('The item id: ' + item.id + ' has been ' + action )
        this.reloadPage()
      }
      console.log(response)
    },
    async booking_details() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/BookingHistory.gql'),
        });
        console.log(response)
        this.history = response.data.bookingDetails
      } catch (error) {
        console.error('Error in update_service:', error);
      }
    },
    getStatusLabel(item) {
      const statusMap = { pending: 0, paid: 1, confirmed: 2, cancelled: 3, completed: 4 };
      const statusLabel = Object.keys(statusMap).find(key => statusMap[key] === parseInt(item.status));
      return statusLabel || 'Unknown'; // Fallback for unknown status
    },
    reloadPage() {
      // Reload the current page
      window.location.reload();
    },
  },
  mounted() {
    this.booking_details()
  }
}
console.log('ok')
</script>

<style>

</style>
