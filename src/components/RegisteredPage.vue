<template>
  <div class="container">
    <div class="service_category_header">
      <h2 class="service_category_title">Manage <span class="service_category_title_name">Registered Users</span></h2>
      <span class="btn btn-success service_category_add_btn">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-people-fill" viewBox="0 0 16 16">
          <path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1H7Zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm-5.784 6A2.238 2.238 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.325 6.325 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1h4.216ZM4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z"/>
        </svg>
        Currently: {{ this.count }} Users
      </span>
    </div>
    <table class="table table-bordered table-hover table-striped">
          <thead>
            <tr>
              <th>No.</th>
              <th>First Name</th>
              <th>Last Name</th>
              <th>Email</th>
              <th>Role</th>
              <th>Joined</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in this.registered" :key="index">
              <td>{{ index + 1 }}</td>
              <td>{{ item.firstName }}</td>
              <td>{{ item.lastName }}</td>
              <td>{{ item.email }}</td>
              <td>{{ item.role }}</td>
              <td>{{ formatTimestamp(item.createdAt) }}</td>
            </tr>
          </tbody>
        </table>
  </div>
</template>

<script>
export default {
  data(){
    return {
      registered: '',
      count: ''
    }
  },
  methods: {
    formatTimestamp(dateTimeString) {
      const timestamp = new Date(dateTimeString).getTime();
      const now = new Date().getTime();
      const diff = now - timestamp;
      const seconds = Math.floor(diff / 1000);
      const minutes = Math.floor(seconds / 60);
      const hours = Math.floor(minutes / 60);
      const days = Math.floor(hours / 24);
      const months = Math.floor(days / 30);
      const years = Math.floor(days / 365);

      if (years > 0) {
        return `joined ${years} ${years === 1 ? 'year' : 'years'} ago`;
      } else if (months > 0) {
        return `joined ${months} ${months === 1 ? 'month' : 'months'} ago`;
      } else if (days > 0) {
        return `joined ${days} ${days === 1 ? 'day' : 'days'} ago`;
      } else if (hours > 0) {
        return `joined ${hours} ${hours === 1 ? 'hour' : 'hours'} ago`;
      } else {
        return `joined ${minutes} ${minutes === 1 ? 'minute' : 'minutes'} ago`;
      }
    },
    async cart_item_category() {
    try {
      const response = await this.$apollo.query({
        query: require('@/graphql/TotalRegistration.gql'),
      });
      console.log(response)
      this.registered = response.data.totalRegistration.users
      this.count = response.data.totalRegistration.count
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
