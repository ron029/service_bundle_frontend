<template>
  <div class="container">
    <div class="row d-flex justify-content-center align-items-center h-100">
      <div class="col-md-6 col-lg-6 col-sm-6">
        <div class="d-flex flex-row align-items-center justify-content-center justify-content-lg-start">
          <p class="login_text lead fw-normal mb-0 me-3"></p>
        </div>
        <form @submit.prevent="submitForm" class="row">
          <div class="col-md-6 col-lg-6">
            <div class="input-field-signin">
              <div :class="{ error: v$.services.name.$errors.length }">
                <label class="form-label">Service Name
                  <input v-model="services.name" class="form-control form-control-l" :class="{ error: v$.services.name.$errors.length }">
                  <div class="input-errors" v-for="error of v$.services.name.$errors" :key="error.$uid">
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </label>
              </div>
            </div>
            <!-- Image -->
            <div class="row input-field-signup mt-3">
              <button id="upload_widget" @click.prevent="" class="cloudinary-button">Change Image</button>
            </div>
            <div class="input-field-signin">
              <div>
                <label class="form-label">
                  <div id="image-preview" class="mt-3"> <!-- This is where the uploaded image will be displayed --> </div>
                  <img v-if="show_old_image" :src="services.image" style="height:200px; width:200px;">

                </label>
              </div>
            </div> 
          </div>
          <!-- Service Category -->
          <div class="col-md-3 col-lg-6">
            <div class="input-field-signin">
              <div :class="{ error: v$.services.service_category.$errors.length }">
                <label class="form-label">name
                  <select v-model="services.service_category" class="form-control form-control-l" :class="{ error: v$.services.service_category.$errors.length }">
                    <option v-for="category in this.services.service_categories" :key="category.id" :value="category.id">
                      {{ category.name }}
                    </option>
                  </select>
                </label>
              </div>
            </div>
            <!-- Description -->
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
            <!-- Price -->
            <div class="input-field-signin">
              <div :class="{ error: v$.services.price.$errors.length }">
                <label class="form-label">Price
                  <input id="price" v-model="services.price" class="form-control form-control-l" :class="{ error: v$.services.price.$errors.length }">
                  <div class="input-errors" v-for="error of v$.services.price.$errors" :key="error.$uid">
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </label>
              </div>
            </div>
          </div>
          <button type="submit" class="btn btn-primary btn-lg input-field-signin">Update</button>
        </form>
      </div>
      <div class="col-md-6 col-lg-6 col-sm-6">
        <span @click="new_time_slot" class="btn btn-primary">New Time Slot</span>
        <table class="table">
          <tr>
            <td>Date</td>
            <td>Start Time</td>
            <td>End Time</td>
            <td>Capacity</td>
            <td>Action</td>
          </tr>
          <tr v-for="item in this.time_slot" :key="item.id">
            <td>{{ item.date }}</td>
            <td>{{ formattedStartTime(item.startTime) }}</td>
            <td>{{ formattedStartTime(item.endTime) }}</td>
            <td>{{ item.capacity }}</td>
            <td>
              <span @click="edit_time_slot(item)" class="btn btn-warning">edit</span>
              <span @click="delete_time_slot(item)" class="btn btn-danger">Delete</span>
            </td>
          </tr>
        </table>
      </div>
      <div class="position-relative edit-time">
        <div v-if="showTime" class="card position-absolute top-50 start-50 translate-middle">
          <div class="card-body">
            <h1></h1>
            <table class="table">
              <tr>
                <td>Date</td>
                <td>Start Time</td>
                <td>End Time</td>
                <td>Capacity</td>
                <td>Action</td>
              </tr>
              <tr v-if="delete_time">
                <td>{{ this.time_slot_one.date }}</td>
                <td>{{ formattedStartTime(this.time_slot_one.startTime) }}</td>
                <td>{{ formattedStartTime(this.time_slot_one.endTime) }}</td>
                <td>{{ this.time_slot_one.capacity }}</td>
                <td><span @click="this.delete_time_save" class="btn btn-danger">Delete</span></td>
              </tr>
              <tr v-if="edit_time">
                <td> <input type="date" v-model="time_slot_one.date"> </td> 
                <td>
                  {{ formattedStartTime(this.time_slot_one.startTime) }}<br>
                  <input type="time" v-model="time_slot_one.startTime">
                </td>
                <td>
                  {{ formattedStartTime(this.time_slot_one.endTime) }}<br>
                  <input type="time" v-model="time_slot_one.endTime">
                </td>
                <td>
                  {{ this.time_slot_one.capacity }}<br>
                  <input type="number" v-model="time_slot_one.capacity">
                </td>
                <td><span @click="this.edit_time_save" class="btn btn-warning">edit</span></td>
              </tr>
            </table>
          </div>
        </div>
      </div>
      <div class="position-relative edit-time">
        <div v-if="createTimeSlot" class="card position-absolute top-50 start-50 translate-middle">
          <div class="card-body">
            <p>please ensure the date is now or in the future</p>
            <p>please ensure the before and after of time, or else it wont save!</p>
            <table class="table">
              <tr>
                <td>Date</td>
                <td>Start Time</td>
                <td>End Time</td>
                <td>Capacity</td>
                <td>Action</td>
              </tr>
              <tr>
                <td> <input type="date" v-model="newts.date"> </td>
                <td> <input type="time" v-model="newts.start_time"> </td>
                <td> <input type="time" v-model="newts.end_time"> </td>
                <td> <input type="number" v-model="newts.capacity"> </td>
                <td><span @click="this.create_time_slot" class="btn btn-success">Create</span></td>
              </tr>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useVuelidate } from '@vuelidate/core';
import { required, integer } from '@vuelidate/validators';
export default {
  name: 'ServiceEdit',
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
      id: '',
      image: '',
      time_slot: [],
      time_slot_one: [],
      showTime: false,
      edit_time: false,
      delete_time: false,
      time_slot_old: {
        start_time: '',
        end_time: '',
        date: '',
        capacity: ''
      },
      time_slot_create: true,
      createTimeSlot: false,
      newts: {
        start_time: '',
        end_time: '',
        date: '',
        capacity: ''
      },
      show_old_image: true,
    }
  },
  validations () {
    return {
      services: {
        name: { required },
        service_category: { required  },
        price: {required, integer },
        description: {required},
        service_categories: {required},
      }
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
                    this.services.image = imageUrl;
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
        this.show_old_image = false;
        const imagePreviewDiv = document.getElementById('image-preview');
        const image = document.createElement('img');
        image.src = imageUrl;
        image.classList.add('uploaded-image'); // Add CSS class for styling
        imagePreviewDiv.innerHTML = ''; // Clear any existing content
        imagePreviewDiv.appendChild(image);
    },
    new_time_slot(){
      this.createTimeSlot = true
    },
    async create_time_slot(){
      const response = await this.$apollo.mutate({
        mutation: require('@/graphql/TimeSlotCreate.gql'),
        variables: {
          "serviceId": this.$route.params.id,
          "date": this.newts.date,
          "startTime": this.newts.start_time,
          "endTime": this.newts.end_time,
          "capacity": this.newts.capacity,
        },
      });
      this.createTimeSlot = false
      if (response) {
        alert('NEW TIMESLOT HAS BEEN ADDED')
        this.reloadPage()
      }
      this.show_time_slot_by_service(this.$route.params.id)
    },
    async edit_time_save() {
      console.log('the id of specific timeslot is now',this.time_slot_one.id)
      console.log("'it is a type of', t")
      console.log(typeof this.time_slot_one.id)
      const parseid = parseInt(this.time_slot_one.id)
      this.showTime = false;
      this.edit_time = false;
      try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/TimeSlotUpdate.gql'),
          variables: {
            "id": parseid,
            "serviceId": this.$route.params.id,
            "date": this.time_slot_one.date,
            "startTime": this.time_slot_one.startTime,
            "endTime": this.time_slot_one.endTime,
            "capacity": parseInt(this.time_slot_one.capacity),
          },
        });
        console.log(response)
        this.time_slot_one = null;
      } catch (error) { console.error("Graphql Error:", error); }
    },
    async delete_time_save(){
      console.log('the object of time slot to delete is',this.time_slot_one.id)
      console.log('the type of id is')
      console.log(typeof parseInt(this.time_slot_one.id))
      try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/TimeSlotDelete.gql'),
          variables: {
            "id": parseInt(this.time_slot_one.id),
          },
        });
        if (response) {
          alert('TIMESLOT HAS BEEN DELETED.')
          this.reloadPage();
        }
        console.log(response)
        this.time_slot_one = null;
      } catch (error) { console.error("Graphql Error:", error); }
      this.showTime = false;
      this.delete_time = false;
      this.time_slot_one = null;
    },
    popupTime(){ this.showTime = true; },
    closeTime(){ this.edit_time = true; },
    async edit_time_slot(item) {
      console.log('edit_time_slot_id is now',parseInt(item.id))
      await this.show_time_slot_one(parseInt(item.id))
      this.edit_time = true;
      this.showTime = true;
    },
    async delete_time_slot(item) {
      console.log('delete_time_slot_id is ',parseInt(item.id))
      await this.show_time_slot_one(parseInt(item.id))
      this.delete_time = true;
      this.showTime = true;
    },
    async submitForm() {
      this.v$.$touch();
      if (!this.v$.$error) {
        this.services.service_category = parseInt(this.services.service_category);
        this.services.price = parseInt(this.services.price);
        console.log(this.services)
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/ServiceUpdate.gql'),
          variables: {
            id: this.services.id,
            serviceCategoryId: this.services.service_category,
            name: this.services.name,
            description: this.services.description,
            price: this.services.price,
            image: this.services.image
          },
        });
        console.log('response after update', response)
        console.log(response.data.updateService.errors.length)
        if (response.data.updateService.errors.length < 1) {
          alert ('YOUR PRODUCT HAS BEEN UPDATED')
          // this.$router.push('/services');
        }
      }
    },
    async show_service(id) {
      const new_id = parseInt(id);
      const response = await this.$apollo.query({
        query: require('@/graphql/AdminServiceFind.gql'),
        variables: { "id": new_id }
      });
      this.services.id = response.data.serviceAdmin[0].id;
      this.services.name = response.data.serviceAdmin[0].name;
      this.services.price = response.data.serviceAdmin[0].price;
      this.services.image = response.data.serviceAdmin[0].image;
      this.services.description = response.data.serviceAdmin[0].description;
      this.services.service_categories = response.data.serviceAdmin[0].serviceCategories;
      this.services.service_category = response.data.serviceAdmin[0].serviceCategoryId.name;
    },
    async show_time_slot() { },
    async show_time_slot_one(id) {
      const new_id = parseInt(id);
      const response = await this.$apollo.query({
        query: require('@/graphql/TimeSlotOne.gql'),
        variables: { "id": new_id }
      });
      this.time_slot_one = response.data.timeSlotOne
      this.time_slot_old.capacity = response.data.timeSlotOne.capacity
      this.time_slot_old.date = response.data.timeSlotOne.date
      this.time_slot_old.end_time = response.data.timeSlotOne.endTime
      this.time_slot_old.start_time = response.data.timeSlotOne.startTime
    },
    async show_time_slot_by_service(id) {
      const new_id = parseInt(id);
      const response = await this.$apollo.query({
        query: require('@/graphql/TimeSlotByService.gql'),
        variables: { "id": new_id }
      });
      this.time_slot = response.data.timeSlotByService
      console.log('TS BY SERVICE',this.time_slot)
    },
    reloadPage() {
      // Reload the current page
      window.location.reload();
    },
    formattedStartTime(time) {
      // Parse the start_time string into a Date object
      const dateObj = new Date(time);

      // Extract the hour, minute, and AM/PM parts
      const hour = dateObj.getUTCHours();
      const minute = dateObj.getUTCMinutes();
      const ampm = hour >= 12 ? "PM" : "AM";

      // Convert to 12-hour format and format the hour and minute as "HH:MM AM/PM"
      const formattedHour = ((hour + 11) % 12 + 1).toString().padStart(2, '0');
      return `${formattedHour}:${minute.toString().padStart(2, '0')} ${ampm}`;
    }
  },
  mounted() {
    this.time_slot
    this.show_service(this.$route.params.id);
    this.show_time_slot(this.$route.params.id);
    this.show_time_slot_by_service(this.$route.params.id);
    this.upload();
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
.form-service-edit {
  display: inline-block;
}
.edit-time {
  margin-top: -390px;
}
.error, .error:focus {
    border-color: red;
    color: red;
}
.input-errors {
    color: red;
}
.form-label {
    position: relative;
}
.error-msg {
    position: absolute;
    font-size: 10px;
    bottom: -13px;
    left: 0px;
}
</style>
