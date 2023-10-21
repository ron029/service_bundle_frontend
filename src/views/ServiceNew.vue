<template>
  <div class="container">
    <div class="service_category_header">
      <h2 class="service_category_title">New <span class="service_category_title_name">Service</span></h2>
      <span class="btn btn-success service_category_add_btn">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-save2-fill" viewBox="0 0 16 16">
          <path d="M8.5 1.5A1.5 1.5 0 0 1 10 0h4a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h6c-.314.418-.5.937-.5 1.5v6h-2a.5.5 0 0 0-.354.854l2.5 2.5a.5.5 0 0 0 .708 0l2.5-2.5A.5.5 0 0 0 10.5 7.5h-2v-6z"/>
        </svg>
        Save New Service
      </span>
    </div>
    <div class="row">
      <div class="col-md-6">
        <form @submit.prevent="submitForm" class="centered-form">
          <div class="input-field-signin">
            <div :class="{ error: v$.services.name.$errors.length }">
              <label class="form-label">Service Name
                <input v-model="services.name" class="form-control form-control-l" :class="{ error: v$.services.name.$errors.length }" ref="service_name">
                <div class="input-errors" v-for="error of v$.services.name.$errors" :key="error.$uid">
                  <div class="error-msg">{{ error.$message }}</div>
                </div>
              </label>
            </div>
          </div>
          <div class="input-field-signin">Service Category
            <div :class="{ error: v$.services.service_category.$errors.length }">
              <select v-model="services.service_category" class="form-control form-control-l" :class="{ error: v$.services.service_category.$errors.length }">
                <option v-for="category in this.services.service_categories" :key="category.id" :value="category.id">
                  {{ category.name }}
                </option>
              </select>
            </div>
          </div>
          <div class="input-field-signin">
            <div :class="{ error: v$.services.description.$errors.length }">
              <label class="form-label">Description
                <textarea v-model="services.description" class="form-control form-control-l" :class="{ error: v$.services.description.$errors.length }"></textarea>
                <div class="input-errors" v-for="error of v$.services.description.$errors" :key="error.$uid">
                  <div class="error-msg">{{ error.$message }}</div>
                </div>
              </label>
            </div>
          </div>
          <div class="input-field-signin">
            <div :class="{ error: v$.services.price.$errors.length }">
              <label class="form-label">Price
                <div class="input-group mb-3" :class="{ error: v$.services.price.$errors.length }">
                  <span class="input-group-text">PHP</span>
                  <input type="text" class="form-control form-control-l" :class="{ error: v$.services.price.$errors.length }" id="price" v-model="services.price" aria-label="Amount (to the nearest dollar)">
                  <span class="input-group-text">.00</span>
                </div>
                <div class="input-errors" v-for="error of v$.services.price.$errors" :key="error.$uid">
                  <div class="error-msg">{{ error.$message }}</div>
                </div>
              </label>
            </div>
          </div>
          <div class="input-field-signin">
            <div class="row input-field-signup mt-3">
              <button id="upload_widget" @click.prevent="" class="cloudinary-button">Upload files</button>
            </div>
            <div id="image-preview" class="mt-3"></div>
            <button type="submit" class="btn btn-primary btn-lg input-field-signin">Create</button>
          </div>
        </form>
      </div>
      <div class="col-md-6">
        <p>Customer's View</p>
        <div class="card service_new_form">
          <div class="card-body service_item">
            <a class="service_link" href="#" @click.prevent>
              <h5>{{ services.name }}</h5>
              <div id="image-preview2" class="mt-3"></div>
              <p class="service_details">{{ services.description }}</p>
              <p class="service_details">{{ formatToPHP(services.price) }}</p>
            </a>
            <table class="table service_details">
              <thead>
                <tr>
                  <th>Schedule</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <div class="time">
                    <datepicker 
                    :use-utc="true"
                    :inline="true"
                    format="MM/DD/yyyy"
                    ></datepicker>
                  </div>
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
import Datepicker from 'vuejs-datepicker';
import { required, integer, maxLength } from '@vuelidate/validators'
import { useVuelidate } from '@vuelidate/core';
export default {
  setup () { return { v$: useVuelidate() } },
  data () {
    return {
      services: {
        service_category: '',
        name: '',
        price: '',
        description: '',
        service_categories: [],
      },
    }
  },
  validations () {
    return {
      services: {
        name: { required, maxLength: maxLength(25) },
        service_category: { required  },
        price: {required, integer },
        description: {required, maxLength: maxLength(100),},
      },
      image: '',
    }
  },
  components: { Datepicker, },
  methods: {
    formatToPHP(number) {
      // Convert the number to a string with two decimal places
      const formattedNumber = Number(number).toFixed(2);

      // Add "PHP " to the formatted number and use commas as a thousands separator
      const result = `PHP ${formattedNumber.replace(/\B(?=(\d{3})+(?!\d))/g, ', ')}`;

      return result;
    },
    upload(){
        console.log('upload')
        var myWidget = window.cloudinary.createUploadWidget({
            cloudName: 'dovxq5gn9', 
            processQueue: false,
            uploadPreset: 'uhjevesg'}, (error, result) => { 
                if (!error && result && result.event === "success") { 
                console.log('Done! Here is the image info: ', result.info); 
                    const imageUrl = result.info.secure_url;
                    this.image = imageUrl;
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
        const imagePreviewDiv = document.getElementById('image-preview');
        const image = document.createElement('img');
        image.src = imageUrl;
        image.classList.add('uploaded-image'); // Add CSS class for styling
        imagePreviewDiv.innerHTML = ''; // Clear any existing content
        imagePreviewDiv.appendChild(image);

        const imagePreviewDiv2 = document.getElementById('image-preview2');
        const image2 = document.createElement('img');
        image2.src = imageUrl;
        image2.classList.add('service_image'); // Add CSS class for styling
        imagePreviewDiv2.innerHTML = ''; // Clear any existing content
        imagePreviewDiv2.appendChild(image2);
    },
    async show_categories() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/Category.gql'),
        });
        console.log('the service category is here', response)
         this.services.service_categories = response.data.categories;
      } catch (error) {
          console.error('Error logging out:', error);
      }
    },
    async submitForm() {
      this.v$.$touch();
      if(!this.v$.$error) {
        console.log()
        try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/ServiceCreate.gql'),
          variables: {
            serviceCategoryId: this.services.service_category,
            name: this.services.name,
            description: this.services.description,
            price: parseInt(this.services.price),
            image: this.image
          },
        });
        let data = this.services;
        data['image'] = this.image;
        data['id'] = response.data.createService.service.id;
        console.log('the data of new services is: ', data);
        console.log('reply from service is: ', response)
        if(response) { alert("SUCCESS, new service has been recorded") }
        this.$emit('newServiceAdded', data);
        this.time_slot_one = null;
        } catch (error) { console.error("Graphql Error:", error); }
      } else {
        console.log(this.v$.services)
      }
    },
    reloadPage() {
      // Reload the current page
      window.location.reload();
    },
  },
  mounted() {
    this.$refs.service_name.focus();
    this.show_categories();
    this.upload();
  },
}
</script>

<style>
.service_new_form {
  width: 390px;
  margin: 0 auto;
}

.centered-form {
  width: 230px;
  margin: 0 auto;
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
</style>