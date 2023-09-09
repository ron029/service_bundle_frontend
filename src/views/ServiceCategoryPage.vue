<template>
  <div class="container">
    <h2>Service Category</h2>
    <div class="">
      <!-- <span @click="toggleUpdateServiceCategory" class="btn btn-primary">New Service Category</span> -->
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
                <td><button id="upload_widget" @click.prevent="" class="cloudinary-button">Upload files</button></td>
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
          <td><img :src="item.image" style="width: 200px; height: 150px;"></td>
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
        UpdateServiceCategory: true,
        update: {
          name: '',
          description: '',
          id: '',
          image: ''
        },
        createNewServiceCategory: true,
        updateNewServiceCategory: false,
      }
  },
  props: ['serviceCategoryId'],
  name: 'ServiceCategoryPage',
  methods: {
    upload(){
        console.log('upload')
        var myWidget = window.cloudinary.createUploadWidget({
            cloudName: 'dovxq5gn9', 
            processQueue: false,
            uploadPreset: 'uhjevesg'}, (error, result) => {
                if (!error && result && result.event === "success") {
                console.log('Done! Here is the image info: ', result.info); 
                    const imageUrl = result.info.secure_url;
                    this.update.image = imageUrl;
                    // this.displayImage(imageUrl);
                }
            }
        )
        document.getElementById("upload_widget").addEventListener("click", function(){
            myWidget.open();
        }, false);  
    }, 
    // Function to display the uploaded image
    // displayImage(imageUrl) {
    //     this.show_old_image = false;
    //     const imagePreviewDiv = document.getElementById('image-preview');
    //     const image = document.createElement('img');
    //     image.src = imageUrl;
    //     image.classList.add('uploaded-image'); // Add CSS class for styling
    //     imagePreviewDiv.innerHTML = ''; // Clear any existing content
    //     imagePreviewDiv.appendChild(image);
    // },
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
            name: this.update.name,
            description: this.update.description,
            image: this.update.image
          },
        });
        if (response) {
          alert('NEW CATEGORY HAS BEEN ADDED');
          this.reloadPage();
        }
      } catch (error) {
        console.error('GraphQL Error:', error);
      }
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
            "description": this.update.description,
            "image": this.update.image
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
        this.update.image = response.data.serviceCategory[0].image
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
    this.upload()
  }
}
</script>

<style>
.cloudinary-button {
    background-color: #007bff;
    color: white;
    padding: 10px 20px;
    border: none;
    cursor: pointer;
}
.cloudinary-button:hover {
    background-color: #0056b3;
}
/* Style the uploaded image */
.uploaded-image {
    max-width: 100%;
    height: auto;
    margin-top: 10px;
    border: 1px solid #ccc;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
.link_text {
    display: inline-block;
}
.edit-time {
  margin-top: -100px;
}
</style>
