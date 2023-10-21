<template>
  <div class="container">
    <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasRight" aria-labelledby="offcanvasRightLabel">
      <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="offcanvasRightLabel">{{ service_action }}</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
      </div>
      <div class="offcanvas-body">
        <div v-if="UpdateServiceCategory">
          <div class="card-body">
            <form class="unique-vertical-form">
              <div class="unique-form-group">
                <label for="categoryName">Name</label>
                <input id="categoryName" v-model="update.name" type="text" placeholder="Enter Category Name" ref="service_category_name" class="unique-input">
              </div>
              <div class="unique-form-group">
                <label for="categoryDescription">Description</label>
                <textarea id="categoryDescription" v-model="update.description" type="text" placeholder="Enter Description" class="unique-input"></textarea>
              </div>
              <div class="unique-form-group">
                <label>Image</label>
                <div id="image-preview" class="mt-3"></div>
                <button id="upload_widget" @click.prevent="" class="unique-cloudinary-button">Upload files</button>
              </div>
              <div class="unique-form-group">
                <span @click="create_service_category" v-if="createNewServiceCategory" class="unique-btn unique-btn-success">CREATE</span>
                <span @click="update_service_category" v-if="updateNewServiceCategory" class="unique-btn unique-btn-warning" ref="save_edit" data-bs-dismiss="offcanvas" aria-label="Close">SUBMIT</span>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    <div class="service_category_header">
      <h2 class="service_category_title">Manage <span class="service_category_title_name">Service Categories</span></h2>
      <span @click="toggleUpdateServiceCategory" class="btn btn-success service_category_add_btn"  data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-controls="offcanvasRight">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-circle-fill" viewBox="0 0 16 16">
          <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8.5 4.5a.5.5 0 0 0-1 0v3h-3a.5.5 0 0 0 0 1h3v3a.5.5 0 0 0 1 0v-3h3a.5.5 0 0 0 0-1h-3v-3z"/>
        </svg>
        Add New Service Category
      </span>
    </div>
    <div class="table-responsive table-container">
      <table class="table service_category_tbl table-bordered">
        <thead>
          <tr>
            <th>No.</th>
            <th>Image</th>
            <th>Name</th>
            <th>Description</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in this.services.service_categories" :key="item.id">
            <td>{{ index + 1 }}</td>
            <td><img :src="item.image" style="width: 200px; height: 150px;"></td>
            <td>{{ item.name }}</td>
            <td>{{ item.description }}</td>
            <td class="no-wrap">
              <span @click="show_category_one(item, index)" class="btn btn-warning service_category_edit_btn" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-controls="offcanvasRight">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-pen-fill" viewBox="0 0 16 16">
                  <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001z"/>
                </svg>
              </span>
              <span @click="delete_category(item, index)" class="btn btn-danger service_category_delete_btn">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-trash-fill" viewBox="0 0 16 16">
                  <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1H2.5zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5zM8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5zm3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0z"/>
                </svg>
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  data() {
      return {
        service_action: '',
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
        update_category_index: 0,
        delete_category_index: 0
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
                    this.displayImage(imageUrl);
                }
            }
        )
        document.getElementById("upload_widget").addEventListener("click", function(){
            myWidget.open();
        }, false);  
    },
    // Function to display the uploaded image
    displayImage(imageUrl) {
        // this.show_old_image = false;
        const imagePreviewDiv = document.getElementById('image-preview');
        const image = document.createElement('img');
        image.src = imageUrl;
        image.classList.add('uploaded-image'); // Add CSS class for styling
        imagePreviewDiv.innerHTML = ''; // Clear any existing content
        imagePreviewDiv.appendChild(image);
    },
    toggleUpdateServiceCategory(){
      const imagePreviewDiv = document.getElementById('image-preview');
      imagePreviewDiv.innerHTML = '';

      this.service_action = 'New Service Category';
      // Wait for 1 second (1000 milliseconds) before focusing on the input element
      setTimeout(() => {
        this.$refs.service_category_name.focus();
      }, 400);
      this.update.name = '';
      this.update.description = '';
      this.update.image = '';
      this.update.id = '';
      if (this.UpdateServiceCategory == false) this.UpdateServiceCategory = true;

      this.createNewServiceCategory = true;
      this.updateNewServiceCategory = false;
    },
    async create_service_category() {
      console.log('begin remove form');
      const offcanvasElement = document.getElementById('offcanvasRight');
      offcanvasElement.addEventListener('click', async () => {
        // Toggle the "hiding" class on the offcanvasElement
        try {
          const response = await this.$apollo.mutate({
            mutation: require('@/graphql/ServiceCategoryCreate.gql'),
            variables: {
              name: this.update.name,
              description: this.update.description,
              image: this.update.image
            },
          });
          if (response.data.createServiceCategory.errors.length < 1) {
            // alert('New Product named "' + response.data.name + '" has been added.');
            offcanvasElement.classList.add('hiding');
          
            setTimeout(() => {
              // Remove the "hiding" class and set the "offcanvas" and "offcanvas-end" classes explicitly
              offcanvasElement.classList.remove('hiding');
              offcanvasElement.classList.remove('show');

              document.body.removeAttribute('data-bs-overflow');
              document.body.removeAttribute('style');

              const backdropElement = document.querySelector('.offcanvas-backdrop.fade.show');
              if (backdropElement) backdropElement.remove();
              
              offcanvasElement.removeAttribute('aria-modal');
              offcanvasElement.removeAttribute('role');
            }, 500);

            let data = response.data.createServiceCategory.serviceCategory;
            this.services.service_categories.push(data);
            console.log('the details for new product is: ', response);
          }
        } catch (error) {
          console.error('GraphQL Error:', error);
        }
      });
      console.log('end remove form');
      const imagePreviewDiv = document.getElementById('image-preview');
      imagePreviewDiv.innerHTML = '';
    },
    async show_categories() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/Category.gql'),
        });
        this.services.service_categories = response.data.categories;
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
          let edit = this.services.service_categories[this.update_category_index];
          edit.name = this.update.name;
          edit.description = this.update.description;
          edit.image = this.update.image;
          console.log('this is the thing that we need to edit: ', edit);
          console.log('the new data is now: ', edit)
          alert('YOUR SERVICE CATEGORY HAS BEEN UPDATE');
          // this.reloadPage()
        }
      } catch (error) { console.error("Graphql Error:", error); }
    },
    async show_category_one(item, index) {
      this.service_action = 'Modify Service Category (' + item.name + ')';
      console.log('modifying service category with index: ', index)
      this.update_category_index = index;
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
        this.$refs.save_edit.focus();
        this.update.name = response.data.serviceCategory[0].name;
        this.update.description = response.data.serviceCategory[0].description
        this.update.id = response.data.serviceCategory[0].id
        this.UpdateServiceCategory = true;
        this.update.image = response.data.serviceCategory[0].image;
        this.displayImage(this.update.image);
        console.log('File to edit', this.update)
      } catch (error) { console.error("Graphql Error:", error); }
    },
    async delete_category(item, index){
      const userConfirmed = window.confirm("Do you want to delete " + item.name + " category?");
      if (userConfirmed) {
        console.log('deleting service category with index: ', index);
        this.delete_category_index = index;
        try {
          const response = await this.$apollo.mutate({
            mutation: require('@/graphql/ServiceCategoryDelete.gql'),
            variables: {
              "id": parseInt(item.id)
            },
          });
          console.log(response)
          alert('DELETION COMPLETE!')
          console.log('the item to delete is ');
          this.services.service_categories.splice(this.delete_category_index, 1);
          console.log('File to edit', this.update)
        } catch (error) { console.error("Graphql Error:", error); }
      }
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
.service_category_header {
  height: 80px;
  background-color: #435D7D;
  position: relative;
}

.service_category_title, .service_category_add_btn {
  top: 20px;
  position: absolute;
  display: inline-block;
}

.service_category_title_name {
  font-weight: bolder;
}

.service_category_title {
  left: 20px;
  color: white;
}

.service_category_add_btn {
  right: 20px;
}

.btn-success.service_category_add_btn {
  border-radius: 0;
}

.service_category_edit_btn, .service_category_delete_btn {
  background-color: #f6f6f6;
  border: none;
  border-radius: 0;
}

.service_category_edit_btn:hover, .service_category_delete_btn {
  color: white;
}

.service_category_edit_btn {
  color: #FEC61E;
}

.service_category_delete_btn {
  color: red;
}

#offcanvasRight {
  width: 700px;
}

/* form */
/* Unique styles for the form container */
.unique-vertical-form {
  display: flex;
  flex-direction: column;
  max-width: 400px; /* Adjust the maximum width as needed */
  margin: 0 auto; /* Center the form horizontally */
  padding: 20px;
  background-color: #f4f4f4;
  border-radius: 5px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

/* Unique styles for form groups */
.unique-form-group {
  margin-bottom: 20px;
}

/* Unique styles for labels */
.unique-form-group label {
  font-weight: bold;
  color: #333;
}

/* Unique styles for input fields */
.unique-input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

/* Unique styles for the "Upload" button */
.unique-cloudinary-button {
  display: block;
  background-color: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  border-radius: 4px;
  width: 100%;
}

/* Unique styles for buttons */
.unique-btn {
  cursor: pointer;
  padding: 10px 20px;
  border-radius: 4px;
}

/* Unique styles for the "CREATE" button */
.unique-btn-success {
  background-color: #28a745;
  color: white;
}

/* Unique styles for the "SUBMIT" button */
.unique-btn-warning {
  background-color: #ffc107;
  color: #333;
}

.table td {
  color: rgb(100, 99, 99);
}

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
