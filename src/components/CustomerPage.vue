<template>
  <div class="container">
    <h1>Service Category</h1>
    <div class="container">
      <div class="row">
        <div v-for="(item, index) in this.service_categories" :key="index" class="col-md-4 mb-3">
          <a class="service_category_link" :href="getServiceCategoryURL(item)">
            <div class="card">
              <div class="card-body">
                <!-- Display the content of each box here -->
                <h1 class="service_category_header">{{ item.name }}</h1>
                <p>{{ item.description }}</p>
                <img :src="item.image" width="200px" height="200px">
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
        const response = await this.$apollo.query({ query: require('@/graphql/Category.gql'), });
        this.service_categories = response.data.categories;
      } catch (error) {
        console.error('Error creating like:', error);
      }
    },
    getServiceCategoryURL(item) { return `/service_categories/${item.id}`; }
  }, 
  mounted(){
    this.get_service_categories(this.$route.params.id)
  }
}
</script>

<style>
.service_category_header {
  text-decoration: none;
}

.service_category_link {
  text-decoration: none;
  border: 5px solid transparent; /* Start with a transparent border */
  transition: border-color 0.3s ease; /* Add a transition effect for border-color */
}

.card:hover {
  border-color: powderblue;
}
</style>
