<template>
  <div class="container">
    <h2>Service Category</h2>
    <div class="">
      <span @click="toggleUpdateServiceCategory" class="btn btn-primary">New Service Category</span>
      <div v-if="UpdateServiceCategory" class="card">
        <div class="card-body">
          <table class="table">
            <thead>
              <tr>
                <td>Name</td>
                <td>Description</td>
                <td>Image</td>
                <td>Action</td>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td> 
                  <input v-model="update.name"> 
                </td>
                <td>
                  <input v-model="update.description"> 
                </td>
                <td> <input type="file" ></td>
                <td>
                  <span @click="this.create_service_category" v-if="createNewServiceCategory" class="btn btn-success">CREATE</span>
                  <span @click="this.update_service_category" v-if="updateNewServiceCategory" class="btn btn-warning">SUBMIT</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    <table class="table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Description</th>
          <th>Image</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in this.services.service_categories" :key="item.id">
          <td>{{ item.name }}</td>
          <td>{{ item.description }}</td>
          <td>Img</td>
          <td>
            <span @click="show_category_one(item)" class="btn btn-warning">edit</span><br>
            <span @click="delete_category(item)" class="btn btn-danger">delete</span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  data() {
      return {
        services: {
          service_categories: null
        },
        UpdateServiceCategory: false,
        update: {
          name: '',
          description: '',
          id: ''
        },
        createNewServiceCategory: false,
        updateNewServiceCategory: false,
      }
  },
  props: ['serviceCategoryId'],
  name: 'ServiceCategoryPage',
  methods: {
    
    toggleUpdateServiceCategory(){
      if (this.UpdateServiceCategory == false) this.UpdateServiceCategory = true;

      this.createNewServiceCategory = true;
      this.updateNewServiceCategory = false;
    },
    async create_service_category() {
      try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/ServiceCategoryCreate.gql'),
          variables: {
            "name": this.update.name,
            "description": this.update.description,
          },
        });
        if (response) {
          alert('NEW CATEGORY HAS BEEN ADDED')
          this.reloadPage()
        }
      } catch (error) { console.error("Graphql Error:", error); }
    },
    async show_categories() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/Categories.gql'),
        });
        this.services.service_categories = response.data.categories;
        console.log('the category object is here', this.services.service_categories)
      } catch (error) {
          console.error('Error logging out:', error);
      }
    },
    async update_service_category() {
      console.log('id of file to edit', this.update.id);
      try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/ServiceCategoryUpdate.gql'),
          variables: {
            "id": parseInt(this.update.id),
            "name": this.update.name,
            "description": this.update.description
          },
        });
        if (response) {
          alert('YOUR SERVICE CATEGORY HAS BEEN UPDATE');
          this.reloadPage()
        }
      } catch (error) { console.error("Graphql Error:", error); }
    },
    async show_category_one(item) {
      this.createNewServiceCategory = false;
      this.updateNewServiceCategory = true;
      console.log('the category to edit is ',item.id)
      try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/ServiceCategoryFind.gql'),
          variables: {
            "id": parseInt(item.id)
          },
        });
        this.update.name = response.data.serviceCategory[0].name;
        this.update.description = response.data.serviceCategory[0].description
        this.update.id = response.data.serviceCategory[0].id
        this.UpdateServiceCategory = true;
        console.log('File to edit', this.update)
      } catch (error) { console.error("Graphql Error:", error); }
    },
    async delete_category(item){
      try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/ServiceCategoryDelete.gql'),
          variables: {
            "id": parseInt(item.id)
          },
        });
        console.log(response)
        alert('DELETION COMPLETE!')
        this.reloadPage();
        console.log('File to edit', this.update)
      } catch (error) { console.error("Graphql Error:", error); }
    },
    reloadPage() {
      // Reload the current page
      window.location.reload();
    },
  },
  components: {

  },
  mounted(){
    this.show_categories();
  }
}
</script>

<style>
.edit-time {
  margin-top: -100px;
}
</style>
