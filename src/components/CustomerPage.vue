<template>
  <div class="container">
    <div class="jumbotron">
      <video autoplay loop muted>
        <source src="https://res.cloudinary.com/dovxq5gn9/video/upload/v1696256736/xvwogy_1_bmk2b2.mp4" type="video/mp4" />
      </video>

      <div class="text-content">
        <h1 class="display-4 service_category_title_home">Welcome to Service Bundle</h1>
        <p class="lead">Discover, Book, and Experience the Best Local Services Near You</p>
        <hr class="my-4">
        <p>With Service Bundle, you're just a few taps away from enjoying top-notch services at your preferred time and location. We've simplified the way you book appointments, so you can focus on what truly matters – pampering yourself and looking your best!</p>
      </div>
    </div>

    <div class="row">
      <div v-for="(item, index) in this.service_categories" :key="index" class="col-md-4 mb-3">
        <a class="service_category_link" :href="getServiceCategoryURL(item)">
          <div class="card">
            <div class="card-body">
              <!-- Display the content of each box here -->
              <h1 class="service_category_header_homepage">{{ item.name }}</h1>
              <p>{{ item.description }}</p>
              <img :src="item.image" class="service_category_image">
            </div>
          </div>
        </a>
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
.service_category_header_homepage {
  text-decoration: none;
}

.service_category_link {
  text-decoration: none;
  border: 5px solid transparent; /* Start with a transparent border */
  transition: border-color 0.3s ease; /* Add a transition effect for border-color */
}

.service_category_image {
  max-width: 100%; /* Ensure the image scales down proportionally */
  height: auto;    /* Maintain the aspect ratio */
  width: 390px;    /* Set a maximum width if needed */
  max-height: 200px; /* Optionally, set a maximum height */
}

.card:hover {
  border-color: powderblue;
}

/* Style for the video container */
.jumbotron {
  border-radius: 5px;
  margin-top: 20px;
  position: relative;
  overflow: hidden;
  width: 100%;
  height: 400px; /* Adjust the height as needed */
}

/* Style for the video */
video {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* Style for the text content */
.text-content {
  color: #ddd;
  height: 400px;
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  padding: 20px;
  background-color: rgba(255, 255, 255, 0.2);
  z-index: 3;
}

.service_category_title_home {
  font-family: 'Dela Gothic One', cursive;
  margin-top: 57px;
  margin-bottom: 20px;
  position: relative;
  z-index: 3; /* Place it above the pseudo-element */
}
</style>
