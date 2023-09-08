<template>
  <div class="container">
    <h1>Customer Dashboard</h1>
    <div class="container">
      <div class="row">
        <div v-for="(item, index) in this.service_categories" :key="index" class="col-md-4 mb-3">
          <a :href="getServiceCategoryURL(item)">
            <div class="card">
              <div class="card-body">
                <!-- Display the content of each box here -->
                {{ item.name }}
              </div>
            </div>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerPage',
  data(){
    return {
      service_categories: [],
    }
  },
  methods: {
    async get_service_categories() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/Categories.gql'),
        });
        this.service_categories = response.data.categories;
      } catch (error) { 
        console.error('Error creating like:', error);
      }
    },
    getServiceCategoryURL(item) {
      return `/service_categories/${item.id}`;
      // return `/service_categories/:categoryId/services/:serviceId`
    }
  }, 
  mounted(){
    this.get_service_categories(this.$route.params.id)
  }
}
</script>

<style>

</style>
