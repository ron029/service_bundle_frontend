<template>
  <div>
    <h1>New Service</h1>
    <form @submit.prevent="submitForm">
      <div class="input-field-signin">
        <div :class="{ error: v$.services.name.$errors.length }">
          <label class="form-label">services name
            <input v-model="services.name" class="form-control form-control-l" :class="{ error: v$.services.name.$errors.length }">
            <div class="input-errors" v-for="error of v$.services.name.$errors" :key="error.$uid">
              <div class="error-msg">{{ error.$message }}</div>
            </div>
          </label>
        </div>
      </div>
      <div class="input-field-signin">
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
          <label class="form-label">description
            <textarea v-model="services.description" class="form-control form-control-l" :class="{ error: v$.services.description.$errors.length }"></textarea>
            <div class="input-errors" v-for="error of v$.services.description.$errors" :key="error.$uid">
              <div class="error-msg">{{ error.$message }}</div>
            </div>
          </label>
        </div>
      </div>
      <div class="input-field-signin">
        <div :class="{ error: v$.services.price.$errors.length }">
          <label class="form-label">price
            <input id="price" v-model="services.price" class="form-control form-control-l" :class="{ error: v$.services.price.$errors.length }">
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
</template>

<script>
import { required, integer } from '@vuelidate/validators'
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
        name: { required },
        service_category: { required  },
        price: {required, integer },
        description: {required},
      },
      image: '',
    }
  },
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
    },
    async show_categories() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/Categories.gql'),
        });
        console.log('the service category is here', response)
         this.services.service_categories = response.data.categories;
      } catch (error) {
          console.error('Error logging out:', error);
      }
    },
    async submitForm() {
      this.v$.$touch();
      if(!this.v$.$touch()) {
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
        if(response) {
          alert("SUCCESS, new service has been recorded")
        }
        this.time_slot_one = null;
        } catch (error) { console.error("Graphql Error:", error); }
      }
    }
  },
  components: {

  },
  mounted() {
    this.show_categories()
  },

}
</script>

<style>

</style>