<template>
  <div>
    <h1>Registered Page</h1>
    <p>Currently: {{ this.count }} Users</p>
    <table class="table">
          <thead>
            <tr>
              <th>First Name</th>
              <th>Last Name</th>
              <th>Role</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in this.registered" :key="index">
              <td>{{ item.firstName }}</td>
              <td>{{ item.lastName }}</td>
              <td>{{ item.role }}</td>
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
