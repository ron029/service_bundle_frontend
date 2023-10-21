<template>
  <div class="container">
    <!-- Start Modal -->
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="exampleModalLabel">
              <span v-if="createTimeSlot">New Timeslot for</span>
              <span v-else-if="edit_time">Edit timeslot for</span>
              <span v-else>Delete timeslot for</span>
              <span class="service_category_title_name"> Service ({{ service_old_name }})</span>
            </h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form class="unique-vertical-form" v-if="new_time_slot">
              <div class="row input-field-signup mt-3">
                <div class="col-sm-6 col-form-label">
                  <div :class="{ error: v$.newts.start_date.$errors.length }">
                    <label class="form-label" for="start_date">Start Date</label>
                  </div>
                </div>
                <div class="col-sm-6 err-card">
                  <input type="date" v-model="newts.start_date" class="form-control form-control-l" :class="{ error: v$.newts.start_date.$errors.length }" id="start_date" :disabled="delete_time">
                  <div class="input-errors" v-for="error of v$.newts.start_date.$errors" :key="error.$uid">
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </div>
              </div>
              <div class="row input-field-signup mt-3">
                <div class="col-sm-6 col-form-label">
                  <div :class="{ error: v$.newts.end_date.$errors.length }">
                    <label class="form-label" for="end_date">End Date</label>
                  </div>
                </div>
                <div class="col-sm-6 err-card">
                  <input type="date" v-model="newts.end_date" class="form-control form-control-l" :class="{ error: v$.newts.end_date.$errors.length }" id="end_date" :disabled="delete_time">
                  <div class="input-errors" v-for="error of v$.newts.end_date.$errors" :key="error.$uid">
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </div>
              </div>
              <div class="row input-field-signup mt-3">
                <div class="col-sm-6 col-form-label">
                  <div :class="{ error: v$.newts.start_time.$errors.length }">
                    <label class="form-label" for="start_time">Start Time</label>
                  </div>
                </div>
                <div class="col-sm-6 err-card">
                  <input type="time" v-model="newts.start_time" class="form-control form-control-l" :class="{ error: v$.newts.start_time.$errors.length }" id="start_time" :disabled="delete_time">
                  <div class="input-errors" v-for="error of v$.newts.start_time.$errors" :key="error.$uid">
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </div>
              </div>
              <div class="row input-field-signup mt-3">
                <div class="col-sm-6 col-form-label">
                  <div :class="{ error: v$.newts.start_time.$errors.length }">
                    <label class="form-label" for="end_time">End Time</label>
                  </div>
                </div>
                <div class="col-sm-6 err-card">
                  <input type="time" v-model="newts.end_time" class="form-control form-control-l" :class="{ error: v$.newts.start_time.$errors.length }" id="end_time" :disabled="delete_time">
                  <div class="input-errors" v-for="error of v$.newts.end_time.$errors" :key="error.$uid">
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </div>
              </div>
              <div class="row input-field-signup mt-3">
                <div class="col-sm-6 col-form-label">
                  <div :class="{ error: v$.newts.capacity.$errors.length }">
                    <label class="form-label" for="capacity">Capacity</label>
                  </div>
                </div>
                <div class="col-sm-6 err-card">
                  <input type="number" v-model="newts.capacity" class="form-control form-control-l"  :class="{ error: v$.newts.capacity.$errors.length }" id="capacity" :disabled="delete_time">
                  <div class="input-errors" v-for="error of v$.newts.capacity.$errors" :key="error.$uid">
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </div>
              </div>
              <div class="row input-field-signup mt-3">
                <div class="col-sm-6 col-form-label">
                  <div :class="{ error: v$.newts.duration.$errors.length }">
                    <label class="form-label" for="duration">Duration</label>
                  </div>
                </div>
                <div class="col-sm-6 err-card">
                  <input type="number" v-model="newts.duration" class="form-control form-control-l"  :class="{ error: v$.newts.duration.$errors.length }" id="duration" :disabled="delete_time">
                  <div class="input-errors" v-for="error of v$.newts.duration.$errors" :key="error.$uid">
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </div>
              </div>
              <div class="row input-field-signup mt-3">
                <div class="col-sm-6 col-form-label">
                  <div :class="{ error: v$.newts.interval.$errors.length }">
                    <label class="form-label" for="interval">Interval</label>
                  </div>
                </div>
                <div class="col-sm-6 err-card">
                  <input type="number" v-model="newts.interval" class="form-control form-control-l"  :class="{ error: v$.newts.interval.$errors.length }" id="interval" :disabled="delete_time">
                  <div class="input-errors" v-for="error of v$.newts.interval.$errors" :key="error.$uid">
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </div>
              </div>
              <!-- <div class="row input-field-signup mt-3">
                <div class="col-sm-6 col-form-label">
                  <div :class="{ error: v$.first_name.$errors.length }">
                    <label class="form-label" for="first_name">First Name</label>
                  </div>
                </div>
                <div class="col-sm-6 err-card">
                  <input v-model="first_name" class="form-control form-control-l" :class="{ error: v$.first_name.$errors.length }" id="first_name">
                  <div class="input-errors" v-for="error of v$.first_name.$errors" :key="error.$uid" placeholder="Enter your first name" autofocus>
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </div>
              </div> -->
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" id="modal_close" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button v-if="createTimeSlot" type="button" @click="this.create_time_slot" class="btn btn-success">Save new timeslot</button>
            <button v-if="edit_time" type="button" @click="this.edit_time_save" class="btn btn-warning">Update timeslot</button>
            <button v-if="delete_time" type="button" @click="this.delete_time_save" class="btn btn-danger">Delete timeslot</button>
          </div>
        </div>
      </div>
    </div>
    <!-- End Modal -->

    <div class="service_category_header">
      <h2 class="service_category_title">Edit <span class="service_category_title_name">Service ({{ service_old_name }})</span></h2>
    </div>
    <div class="row">
      <div class="col-md-4 col-lg-4">
        <div class="d-flex flex-row align-items-center justify-content-center justify-content-lg-start">
          <p class="login_text lead fw-normal mb-0 me-3"></p>
        </div>
        <form @submit.prevent="submitForm">
          <div class="">
            <div :class="{ error: v$.services.name.$errors.length }">
              <label class="service-edit-label  form-label">Service Name
                <input v-model="services.name" class="form-control" :class="{ error: v$.services.name.$errors.length }">
                <div class="input-errors" v-for="error of v$.services.name.$errors" :key="error.$uid">
                  <div class="error-msg">{{ error.$message }}</div>
                </div>
              </label>
            </div>
          </div>
          <!-- Service Category -->
          <div class="input-field-service-edit">
            <div :class="{ error: v$.services.service_category.$errors.length }">
              <label class="service-edit-label  form-label">Service Category Name
                <select v-model="services.service_category" class="form-control form-control-l" :class="{ error: v$.services.service_category.$errors.length }" id="payment_option">
                  <option v-for="category in this.services.service_categories" :key="category.id" :value="category.id"> {{ category.name }} </option>
                </select>
              </label>
            </div>
          </div>
          <!-- Description -->
          <div class="input-field-service-edit">
            <div :class="{ error: v$.services.description.$errors.length }">
              <label class="service-edit-label  form-label">Description
                <textarea v-model="services.description" class="form-control form-control-l" :class="{ error: v$.services.description.$errors.length }"></textarea>
                <div class="input-errors" v-for="error of v$.services.description.$errors" :key="error.$uid">
                  <div class="error-msg">{{ error.$message }}</div>
                </div>
              </label>
            </div>
          </div>
          <!-- Price -->
          <label class="service-edit-label  form-label" for="price">Price</label>
          <div class="input-group mb-3" :class="{ error: v$.services.price.$errors.length }">
            <span class="input-group-text">PHP</span>
            <input type="text" class="form-control form-control-l price_service_edit" :class="{ error: v$.services.price.$errors.length }" id="price" v-model="services.price" aria-label="Amount (to the nearest dollar)">
            <span class="input-group-text">.00</span>
            <div class="input-errors" v-for="error of v$.services.price.$errors" :key="error.$uid">
              <div class="error-msg">{{ error.$message }}</div>
            </div>
          </div>
          <!-- <div class="input-field-service-edit">
            <div :class="{ error: v$.services.price.$errors.length }">
              <label class="service-edit-label  form-label">Price
                <input id="price" v-model="services.price" class="form-control form-control-l" :class="{ error: v$.services.price.$errors.length }">
                <div class="input-errors" v-for="error of v$.services.price.$errors" :key="error.$uid">
                  <div class="error-msg">{{ error.$message }}</div>
                </div>
              </label>
            </div>
          </div> -->
          <!-- Image -->
          <div class="row d-flex justify-content-center mt-3">
            <button id="upload_widget" @click.prevent="edit" class="cloudinary-button col-md-6">Change Image</button>
          </div>
          <div class="input-field-service-edit">
            <div>
              <label class="service-edit-label  form-label">
                <div id="image-preview" class="mt-3"> <!-- This is where the uploaded image will be displayed --> </div>
                <img v-if="show_old_image" :src="services.image" style="height:200px; width:200px;">
              </label>
            </div>
          </div>
          <div class="d-grid gap-2 mx-auto">
            <button type="submit" class="btn btn-primary service-update-btn">Update Service</button>
          </div>
        </form>
      </div>
      <!-- <div class="col-md-1 col-lg-1"></div> -->
      <div class="col-md-8 col-lg-8 timeslot-panel">
        <div class="time-slot-header">
          <h3 class="time-slot-title">Manage <span class="service_category_title_name">Timeslot</span></h3>
          <span @click="new_time_slot" class="btn btn-success time-slot-add-btn" data-bs-toggle="modal" data-bs-target="#exampleModal">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-circle-fill" viewBox="0 0 16 16">
              <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8.5 4.5a.5.5 0 0 0-1 0v3h-3a.5.5 0 0 0 0 1h3v3a.5.5 0 0 0 1 0v-3h3a.5.5 0 0 0 0-1h-3v-3z"/>
            </svg>
            Add New Timeslot
          </span>
        </div>
        <div class="table-responsive table-container">
          <table class="table table-bordered table-hover table-striped">
            <thead>
              <tr>
                <th>No.</th>
                <th class="no-wrap">Start Date</th>
                <th class="no-wrap">End Date</th>
                <th class="no-wrap">Start Time</th>
                <th class="no-wrap">End Time</th>
                <th>Capacity</th>
                <th>Duration</th>
                <th>Break</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody v-if="time_slot.length > 0">
              <tr v-for="(item, index) in time_slot" :key="item.id">
                <td>{{ index + 1 }}</td>
                <td class="no-wrap">{{ item.startDate }}</td>
                <td class="no-wrap">{{ item.endDate }}</td>
                <td>{{ formattedStartTime(item.startTime) }}</td>
                <td>{{ formattedStartTime(item.endTime) }}</td>
                <td>{{ item.capacity }}</td>
                <td>{{ item.duration }}</td>
                <td>{{ item.interval }}</td>
                <td class="no-wrap">
                  <span @click="edit_time_slot(item, index)" class="btn btn-warning service_category_edit_btn" data-bs-toggle="modal" data-bs-target="#exampleModal">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-pen-fill" viewBox="0 0 16 16">
                      <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001z"/>
                    </svg>
                  </span>
                  <span @click="delete_time_slot(item, index)" class="btn btn-danger service_category_delete_btn" data-bs-toggle="modal" data-bs-target="#exampleModal">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-trash-fill" viewBox="0 0 16 16">
                      <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1H2.5zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5zM8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5zm3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0z"/>
                    </svg>
                  </span>
                </td>
              </tr>
            </tbody>
            <tbody v-else>
              <tr><td colspan="7">There is nothing to show in this table.</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useVuelidate } from '@vuelidate/core';
import { required, integer, minValue, helpers, maxLength } from '@vuelidate/validators';

export default {
  name: 'ServiceEdit',
    setup () { return { v$: useVuelidate() } },
    data () {
    return {
      services: {
        id: '',
        name: '',
        price: '',
        image: '',
        description: '',
        service_categories: [],
        service_category: '',
      },
      service_old_name: '',
      id: '',
      image: '',
      time_slot: [],
      time_slot_one: {
        start_date: '',
        end_date: '',
        start_time: '',
        end_time: '',
        capacity: '',
        id: '',
        duration: '',
        interval: '',
      },
      showTime: false,
      edit_time: false,
      delete_time: false,
      time_slot_create: true,
      createTimeSlot: false,
      index_edit_timeslot: 0,
      newts: {
        id: '',
        start_date: '',
        end_date: '',
        start_time: '',
        end_time: '',
        capacity: '',
        duration: '',
        interval: '',
      },
      show_old_image: true,
      time_slot_index_delete: 0,
    }
  },
  validations () {
    const isBeforeDate = (value, vm) => {
      if (!value) return true;
      console.log(value, vm)
      return new Date(value).getTime() <= new Date(vm.end_date).getTime();
    };
    const isAfterDate = (value, vm) => {
      if (!value) return true;
      console.log(value, vm)
      return new Date(value).getTime() >= new Date(vm.start_date).getTime();
    };
    const isBeforeTime = (value, vm) => {
      if (!value) return true;
      console.log(value, vm);
      return value < vm.end_time;
    };
    const isAfterTime = (value, vm) => {
      if (!value) return true;
      console.log(value, vm);
      return value > vm.start_time;
    };
    return {
      services: {
        name: { required, maxLength: maxLength(25) },
        service_category: { required  },
        price: {required, integer },
        description: {required, maxLength: maxLength(100),},
      },
      newts: {
        start_date: {
          required,
          isBeforeDate: helpers.withMessage("Value must be before end date", isBeforeDate),
        },
        end_date: {
          required,
          isAfterDate: helpers.withMessage("Value must be after start date", isAfterDate),
        },
        start_time: {
          required,
          isBeforeTime: helpers.withMessage("Value must be before end time", isBeforeTime),
        },
        end_time: {
          required,
          isAfterTime: helpers.withMessage("Value must be before start time", isAfterTime),
        },
        capacity: {
          required,
          minValue: minValue(0), // Require a minimum value of 1
          integer,
        },
        duration: {
          minValue: minValue(0), // Require a minimum value of 1
          integer,
        },
        interval: {
          minValue: minValue(0), // Require a minimum value of 1
          integer,
        }
      }
    }
  },
  props: {
    id_to_edit: Number,
    index_to_edit: Number,
  },
  methods: {
    upload(){
      console.log('upload');
      var myWidget = window.cloudinary.createUploadWidget({
        cloudName: 'dovxq5gn9', 
        processQueue: false,
        uploadPreset: 'uhjevesg'
      }, (error, result) => {
        if (!error && result && result.event === "success") { 
          console.log('Done! Here is the image info: ', result.info); 
          const imageUrl = result.info.secure_url;
          this.services.image = imageUrl;
          this.displayImage(imageUrl);
        }
      });
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
      this.edit_time = false;
      this.createTimeSlot = true;
      this.delete_time = false;
      this.newts.start_date = '';
      this.newts.end_date = '';
      this.newts.start_time = '';
      this.newts.end_time = '';
      this.newts.capacity = '';
      this.newts.duration = '';
      this.newts.interval = '';
    },
    async create_time_slot() {
      this.v$.newts.$touch();
      if (this.v$.newts.$error) return;

      const response = await this.$apollo.mutate({
        mutation: require('@/graphql/TimeSlotCreate.gql'),
        variables: {
          "serviceId": this.id_to_edit,
          "startDate": this.newts.start_date,
          "endDate": this.newts.end_date,
          "startTime": this.newts.start_time,
          "endTime": this.newts.end_time,
          "capacity": this.newts.capacity,
          "duration": this.newts.duration,
          "interval": this.newts.interval,
        },
      });
      if (response) {
        const modal_close = document.getElementById('modal_close')
        modal_close.click();
        console.log('serviceEdit: info for new timeslot: ', response)
        console.log('NEW TIMESLOT HAS BEEN ADDED');
        const new_ts_data = response.data.createTimeSlot.timeSlot;
        let index_new_ts = {
          startDate: new_ts_data.startDate,
          endDate: new_ts_data.endDate,
          startTime: new_ts_data.startTime,
          endTime: new_ts_data.endTime,
          id: new_ts_data.id,
          capacity: new_ts_data.capacity,
          duration: new_ts_data.duration,
          interval: new_ts_data.interval,
        }
        this.time_slot.push(index_new_ts);
        // TODO emit timeslot :create
        this.$emit('updateTimeSlot', {index_to_edit: this.index_to_edit, time_slot: this.time_slot});
      }
    },
    async edit_time_save() {
      this.v$.newts.$touch();
      if (this.v$.newts.$error) return;

      try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/TimeSlotUpdate.gql'),
          variables: {
            "id": parseInt(this.newts.id),
            "serviceId": this.id_to_edit,
            "startDate": this.newts.start_date,
            "endDate": this.newts.end_date,
            "startTime": this.newts.start_time,
            "endTime": this.newts.end_time,
            "capacity": parseInt(this.newts.capacity),
            "duration": parseInt(this.newts.duration),
            "interval": parseInt(this.newts.interval),
          },
        });
        if (response.data.updateTimeSlot.errors.length < 0) {
          console.log(response.data.updateTimeSlot.errors);
        } else {
          const modal_close = document.getElementById('modal_close')
          modal_close.click();
          console.log(response)
          console.log('list of timeslot are: ', this.time_slot)
          console.log('index of timeslot to edit is: ', this.index_edit_timeslot)
          this.time_slot[this.index_edit_timeslot]['id'] = parseInt(this.newts.id)
          this.time_slot[this.index_edit_timeslot]['capacity'] = parseInt(this.newts.capacity)
          this.time_slot[this.index_edit_timeslot]['endDate'] = this.newts.end_date
          this.time_slot[this.index_edit_timeslot]['endTime'] = this.formattedLongTime(this.newts.end_time)
          this.time_slot[this.index_edit_timeslot]['startDate'] = this.newts.start_date
          this.time_slot[this.index_edit_timeslot]['startTime'] = this.formattedLongTime(this.newts.start_time)
          this.time_slot[this.index_edit_timeslot]['duration'] = this.newts.duration
          this.time_slot[this.index_edit_timeslot]['interval'] = this.newts.interval
          console.log('list of timeslot after edit: ', this.time_slot);
          // TODO emit timeslot :update
          this.$emit('updateTimeSlot', {index_to_edit: this.index_to_edit, time_slot: this.time_slot});
        }
      } catch (error) { console.error("Graphql Error:", error); }
    },
    async delete_time_save() {
      const modal_close = document.getElementById('modal_close')
      modal_close.click();
      console.log('the object of time slot to delete is',this.newts.id)
      console.log('the type of id is')
      console.log(typeof parseInt(this.newts.id))
      try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/TimeSlotDelete.gql'),
          variables: {
            "id": parseInt(this.newts.id),
          },
        });
        if (response) {
          this.time_slot.splice(this.time_slot_index_delete, 1);
          console.log('TIMESLOT HAS BEEN DELETED.');
          // TODO emit timeslot :delete
          this.$emit('updateTimeSlot', {index_to_edit: this.index_to_edit, time_slot: this.time_slot});
        }
        console.log(response)
        this.time_slot_one = null;
      } catch (error) { console.error("Graphql Error:", error); }
    },
    popupTime(){ this.showTime = true; },
    closeTime(){ this.edit_time = true; },
    async edit_time_slot(item, index) {
      this.index_edit_timeslot = index;
      console.log('edit_time_slot_id is now', parseInt(item.id))
      console.log(typeof item.id)
      await this.show_time_slot_one(parseInt(item.id))
      this.edit_time = true;
      this.createTimeSlot = false;
      this.delete_time = false;
      this.showTime = true;
    },
    async delete_time_slot(item, index) {
      this.time_slot_index_delete = parseInt(index);
      console.log('delete_time_slot_id is ',parseInt(item.id))
      await this.show_time_slot_one(parseInt(item.id), index)
      this.delete_time = true;
      this.showTime = true;
      this.createTimeSlot = false;
      this.edit_time = false;
    },
    async submitForm() {
      this.v$.services.$touch();
      if (this.v$.services.$error) return;
      
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
        this.service_old_name = this.services.name;
        alert ('YOUR PRODUCT HAS BEEN UPDATED');
        // this.$router.push('/services');
      }
    },
    async show_service(id) {
      const new_id = parseInt(id);
      const response = await this.$apollo.query({
        query: require('@/graphql/AdminServiceFind.gql'),
        variables: { "id": new_id }
      });
      console.log(response);
      this.services.id = response.data.serviceAdmin[0].id;
      this.services.name = response.data.serviceAdmin[0].name;
      this.service_old_name = response.data.serviceAdmin[0].name;
      this.services.price = response.data.serviceAdmin[0].price;
      this.services.image = response.data.serviceAdmin[0].image;
      this.services.description = response.data.serviceAdmin[0].description;
      this.services.service_categories = response.data.serviceAdmin[0].serviceCategories;
      this.services.service_category = response.data.serviceAdmin[0].serviceCategoryId.id;
    },
    async show_time_slot_one(id) {
      const new_id = parseInt(id);
      const response = await this.$apollo.query({
        query: require('@/graphql/TimeSlotOne.gql'),
        variables: { "id": new_id }
      });
      // FIXME: timeslot when edit button clicks appears wrong info
      console.log('time slot to edit is: ', response)
      this.newts.id = response.data.timeSlotOne.id;
      this.newts.start_date = response.data.timeSlotOne.startDate;
      this.newts.end_date = response.data.timeSlotOne.endDate;
      this.newts.start_time = this.formattedStartTime(response.data.timeSlotOne.startTime);
      this.newts.end_time = this.formattedStartTime(response.data.timeSlotOne.endTime);
      this.newts.capacity = response.data.timeSlotOne.capacity;
      this.newts.duration = response.data.timeSlotOne.duration;
      this.newts.interval = response.data.timeSlotOne.interval;
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
.timeslot-panel {
  vertical-align: text-top;
  min-height: 680px;
}

table {
  background-color: #f6f6f6;
}

.price_service_edit {
  text-align: right;
}

.service_category_edit_btn {
  color: #FEC61E;
}

.service_category_delete_btn {
  color: red;
}

.service-edit-label {
  width: 100%;
}

.service-update-btn {
  margin-top: 20px;
  border-radius: 0%;
  height: 50px;
  width: 100%;
}

.time-slot-header {
  background-color: red;
  position: relative;
  margin-bottom: 57px;
}

.time-slot-title {
  position: absolute;
  top: 10px;
  left: 10px;
}

.time-slot-add-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  border-radius: 0%;
}

.input-group-text {
  height: 37.9px;
}

.table-container {
  overflow-x: auto; /* Enable horizontal scrolling */
}

.table-container table {
  width: 100%; /* Ensure the table takes up the full width of its container */
  border-collapse: collapse;
}

.table-container th, .table-container td {
  padding: 8px;
  border-bottom: 1px solid #ddd;
}

.table-container th:last-child, .table-container td:last-child {
  position: sticky;
  right: 0;
  /* background-color: #f2f2f2; */
   /* Optional background color for the sticky column */
  z-index: 1; /* Ensure it appears above other elements when sticky */
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
