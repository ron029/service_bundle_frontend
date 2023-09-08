<template>
  <div>
    <ul class="nav nav-tabs" id="myTab" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active" id="home-tab" data-bs-toggle="tab" data-bs-target="#home-tab-pane" type="button" role="tab" aria-controls="home-tab-pane" aria-selected="true">Pending</button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile-tab-pane" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="false">Upcoming</button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="disabled-tab" data-bs-toggle="tab" data-bs-target="#disabled-tab-pane" type="button" role="tab" aria-controls="disabled-tab-pane" aria-selected="false">Cancelled</button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="mostbook-tab" data-bs-toggle="tab" data-bs-target="#mostbook-tab-pane" type="button" role="tab" aria-controls="disabled-tab-pane" aria-selected="false">Completed</button>
      </li>
    </ul>
    <div class="tab-content" id="myTabContent">
      <div class="tab-pane fade show active" id="home-tab-pane" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
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
              <td>{{ item.status }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade" id="profile-tab-pane" role="tabpanel" aria-labelledby="profile-tab" tabindex="0">
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
            <tr v-for="(item, index) in this.paid" :key="index">
              <td>{{ item.service.name }}</td>
              <td>{{ item.date }}</td>
              <td>{{ item.time }}</td>
              <td>{{ item.status }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade" id="contact-tab-pane" role="tabpanel" aria-labelledby="contact-tab" tabindex="0">
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
            <tr v-for="(item, index) in this.confirmed" :key="index">
              <td>{{ item.service.name }}</td>
              <td>{{ item.date }}</td>
              <td>{{ item.time }}</td>
              <td>{{ item.status }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade" id="disabled-tab-pane" role="tabpanel" aria-labelledby="disabled-tab" tabindex="0">
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
            <tr v-for="(item, index) in this.cancelled" :key="index">
              <td>{{ item.service.name }}</td>
              <td>{{ item.date }}</td>
              <td>{{ item.time }}</td>
              <td>{{ item.status }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="tab-pane fade" id="mostbook-tab-pane" role="tabpanel" aria-labelledby="disabled-tab" tabindex="0">
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
            <tr v-for="(item, index) in this.cancelled" :key="index">
              <td>{{ item.service.name }}</td>
              <td>{{ item.date }}</td>
              <td>{{ item.time }}</td>
              <td>{{ item.status }}</td>
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
      pending: '',
      paid: '',
      confirmed: '',
      cancelled: '',
      completed: ''
    }
  },
  methods: {
    async cart_item_category() {
    try {
      const response = await this.$apollo.query({
        query: require('@/graphql/CartItemCategoryCustomer.gql'),
      });
      console.log(response)
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
  }
}
</script>

<style>

</style>

