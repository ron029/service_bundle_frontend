<template>
  <div class="container">
    <h1>Services Customer</h1>
    <div class="row">
      <div v-for="(item, index) in service_by_category" :key="index" class="col-md-4 mb-3">
        <div class="card">
          <div class="card-body">
            <h5>{{ item.name }}</h5>
            <p>Description: {{ item.description }}</p>
            <p>Service Category: {{ item.serviceCategoryId.name }}</p>
            <p>Service Details: {{ item.serviceCategoryId.description }}</p>
            <p>Price: {{ item.price }}</p>
            <table class="table">
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Start Time</th>
                  <th>End Time</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(ite, index2) in item.timeSlot" :key="index2">
                  <td><a :href="getServiceCategoryURL(item, ite)">{{ ite.date }}</a></td>
                  <td>{{ ite.startTime }}</td>
                  <td>{{ ite.endTime }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ServiceListCustomer',
  data() {
    return {
      service_by_category: [],
    }
  },
  methods: {
    async get_service_by_category() {
      console.log('service category id is now', this.serviceCategoryId)
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/ServiceByCategory.gql'),
          variables: { id: parseInt(this.$route.params.categoryId)}
        });
        this.service_by_category = response.data.serviceByCategory;
        console.log(this.service_by_category);
      } catch (error) { 
          console.error('Error creating like:', error);
      }
    },
    getServiceCategoryURL(item, ite) {
      return `/service_categories/${this.$route.params.categoryId}/services/${item.id}/time_slots/${ite.id}`;
    }    
  },
  mounted() {
    this.get_service_by_category()
  } 
}
</script>

<style>

</style>
