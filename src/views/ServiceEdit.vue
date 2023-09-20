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
            <td>Start Date</td>
            <td>End Date</td>
            <td>Start Time</td>
            <td>End Time</td>
            <td>Capacity</td>
            <td>Action</td>
          </tr>
          <tr v-for="(item, index) in time_slot" :key="item.id">
            <td>{{ item.startDate }}</td>
            <td>{{ item.endDate }}</td>
            <td>{{ formattedStartTime(item.startTime) }}</td>
            <td>{{ formattedStartTime(item.endTime) }}</td>
            <td>{{ item.capacity }}</td>
            <td>
              <span @click="edit_time_slot(item, index)" class="btn btn-warning">edit</span>
              <span @click="delete_time_slot(item, index)" class="btn btn-danger">Delete</span>
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
                <td>Start Date</td>
                <td>End Date</td>
                <td>Start Time</td>
                <td>End Time</td>
                <td>Capacity</td>
                <td>Action</td>
              </tr>
              <tr v-if="delete_time">
                <td>{{ this.time_slot_one.start_date }}</td>
                <td>{{ this.time_slot_one.end_date }}</td>
                <td>{{ this.time_slot_one.start_time }}</td>
                <td>{{ this.time_slot_one.end_time }}</td>
                <td>{{ this.time_slot_one.capacity }}</td>
                <td><span @click="this.delete_time_save" class="btn btn-danger">Delete</span></td>
              </tr>
              <tr v-if="edit_time">
                <td> <input type="date" v-model="time_slot_one.start_date"> </td> 
                <td> <input type="date" v-model="time_slot_one.end_date"> </td> 
                <td> <input type="time" v-model="time_slot_one.start_time"> </td>
                <td> <input type="time" v-model="time_slot_one.end_time"> </td>
                <td> <input type="number" v-model="time_slot_one.capacity"> </td>
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
                <td>Start Date</td>
                <td>End Date</td>
                <td>Start Time</td>
                <td>End Time</td>
                <td>Capacity</td>
                <td>Action</td>
              </tr>
              <tr>
                <td> <input type="date" v-model="newts.start_date"> </td>
                <td> <input type="date" v-model="newts.end_date"> </td>
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
      time_slot_one: {
        start_date: '',
        end_date: '',
        start_time: '',
        end_time: '',
        capacity: '',
        id: ''
      },
      showTime: false,
      edit_time: false,
      delete_time: false,
      time_slot_create: true,
      createTimeSlot: false,
      index_edit_timeslot: 0,
      newts: {
        start_date: '',
        end_date: '',
        start_time: '',
        end_time: '',
        capacity: ''
      },
      show_old_image: true,
      time_slot_index_delete: 0,
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
  props: {
    id_to_edit: Number,
    index_to_edit: Number,
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
          "serviceId": this.id_to_edit,
          "startDate": this.newts.start_date,
          "endDate": this.newts.end_date,
          "startTime": this.newts.start_time,
          "endTime": this.newts.end_time,
          "capacity": this.newts.capacity,
        },
      });
      this.createTimeSlot = false
      if (response) {
        console.log('serviceEdit: info for new timeslot: ', response)
        alert('NEW TIMESLOT HAS BEEN ADDED');
        const new_ts_data = response.data.createTimeSlot.timeSlot;
        let index_new_ts = {
          startDate: new_ts_data.startDate,
          endDate: new_ts_data.endDate,
          startTime: new_ts_data.startTime,
          endTime: new_ts_data.endTime,
          id: new_ts_data.id,
          capacity: new_ts_data.capacity
        }
        this.time_slot.push(index_new_ts);
        // TODO emit timeslot :create
        this.$emit('updateTimeSlot', {index_to_edit: this.index_to_edit, time_slot: this.time_slot});
      }
    },
    async edit_time_save() {
      console.log('the id of specific timeslot is now',this.time_slot_one.id)
      console.log("'it is a type of', t")
      console.log(typeof this.time_slot_one.id)
      const parseid = parseInt(this.time_slot_one.id)
      this.showTime = false;
      this.edit_time = false;
      try {
        console.log('data for update: ',this.time_slot_one)
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/TimeSlotUpdate.gql'),
          variables: {
            "id": parseid,
            "serviceId": this.id_to_edit,
            "startDate": this.time_slot_one.start_date,
            "endDate": this.time_slot_one.end_date,
            "startTime": this.time_slot_one.start_time,
            "endTime": this.time_slot_one.end_time,
            "capacity": parseInt(this.time_slot_one.capacity),
          },
        });

        if (response.data.updateTimeSlot.errors.length < 0) {
          console.log(response.data.updateTimeSlot.errors);
        } else {
          console.log(response)
          console.log('list of timeslot are: ', this.time_slot)
          console.log('index of timeslot to edit is: ', this.index_edit_timeslot)
          this.time_slot[this.index_edit_timeslot]['id'] = parseid
          this.time_slot[this.index_edit_timeslot]['capacity'] = parseInt(this.time_slot_one.capacity)
          this.time_slot[this.index_edit_timeslot]['endDate'] = this.time_slot_one.end_date
          this.time_slot[this.index_edit_timeslot]['endTime'] = this.formattedLongTime(this.time_slot_one.end_time)
          this.time_slot[this.index_edit_timeslot]['startDate'] =  this.time_slot_one.start_date
          this.time_slot[this.index_edit_timeslot]['startTime'] = this.formattedLongTime(this.time_slot_one.start_time)
          console.log('list of timeslot after edit: ', this.time_slot);
          // TODO emit timeslot :update
          this.$emit('updateTimeSlot', {index_to_edit: this.index_to_edit, time_slot: this.time_slot});
        }
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
          this.time_slot.splice(this.time_slot_index_delete, 1);
          alert('TIMESLOT HAS BEEN DELETED.');
          // TODO emit timeslot :delete
          this.$emit('updateTimeSlot', {index_to_edit: this.index_to_edit, time_slot: this.time_slot});
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
    async edit_time_slot(item, index) {
      this.index_edit_timeslot = index;
      console.log('edit_time_slot_id is now', parseInt(item.id))
      console.log(typeof item.id)
      await this.show_time_slot_one(parseInt(item.id))
      this.edit_time = true;
      this.showTime = true;
    },
    async delete_time_slot(item, index) {
      this.time_slot_index_delete = parseInt(index);
      console.log('delete_time_slot_id is ',parseInt(item.id))
      await this.show_time_slot_one(parseInt(item.id), index)
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
        this.$emit('updateServicePage', {index_to_edit: this.index_to_edit, service_details: this.services})
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
    async show_time_slot_one(id) {
      const new_id = parseInt(id);
      const response = await this.$apollo.query({
        query: require('@/graphql/TimeSlotOne.gql'),
        variables: { "id": new_id }
      });
      // FIXME: timeslot when edit button clicks appears wrong info
      console.log('time slot to edit is: ', response)
      this.time_slot_one.id = response.data.timeSlotOne.id;
      this.time_slot_one.capacity = response.data.timeSlotOne.capacity
      this.time_slot_one.start_date = response.data.timeSlotOne.startDate;
      this.time_slot_one.end_date = response.data.timeSlotOne.endDate;
      this.time_slot_one.end_time = this.formattedStartTime(response.data.timeSlotOne.endTime);
      this.time_slot_one.start_time = this.formattedStartTime(response.data.timeSlotOne.startTime);
    },
    async show_time_slot_by_service(id) {
      const new_id = parseInt(id);
      const response = await this.$apollo.query({
        query: require('@/graphql/TimeSlotByService.gql'),
        variables: { "id": new_id }
      });

      this.time_slot = response.data.timeSlotByService
      console.log('TS BY SERVICE', this.time_slot)
    },
    reloadPage() {
      // Reload the current page
      window.location.reload();
    },
    formattedLongTime(time) {
      // Parse the input time string into a Date object
      const inputTime = new Date(`2000-01-01T${time}`);
      
      // Calculate the UTC equivalent time
      const utcTime = new Date(inputTime.getTime() - inputTime.getTimezoneOffset() * 60000);

      // Format the UTC time as "YYYY-MM-DD HH:mm:ss UTC"
      const formattedDatetime = utcTime.toISOString().replace('T', ' ').replace(/\.\d+Z$/, ' UTC');

      return formattedDatetime;
    },
    formattedStartTime(time) {
      // Remove "UTC" from the end of the input datetime string
      const timeWithoutUTC = time.replace(' UTC', '');

      // Parse the datetime string into a Date object
      const dateObj = new Date(timeWithoutUTC);

      // Extract the hour, minute, and second parts
      const hour = dateObj.getHours();
      const minute = dateObj.getMinutes();
      const second = dateObj.getSeconds();

      // Format the hour, minute, and second as "HH:MM:SS"
      const formattedHour = hour.toString().padStart(2, '0');
      const formattedMinute = minute.toString().padStart(2, '0');
      const formattedSecond = second.toString().padStart(2, '0');

      return `${formattedHour}:${formattedMinute}:${formattedSecond}`;
    }
  },
  mounted() {
    this.show_service(this.id_to_edit);
    this.show_time_slot_by_service(this.id_to_edit);
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
