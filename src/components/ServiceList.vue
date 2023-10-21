<template>
  <div class="container">
    <div class="service_category_header">
      <h2 class="service_category_title">Manage <span class="service_category_title_name">Services</span></h2>
      <span @click="showServiceNew" class="btn btn-success service_category_add_btn">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-circle-fill" viewBox="0 0 16 16">
          <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8.5 4.5a.5.5 0 0 0-1 0v3h-3a.5.5 0 0 0 0 1h3v3a.5.5 0 0 0 1 0v-3h3a.5.5 0 0 0 0-1h-3v-3z"/>
        </svg>
        Add New Service
      </span>
    </div>
    <div class="table-responsive table-container">
      <table class="table table-bordered">
        <thead>
          <tr>
            <th>No.</th>
            <th class="no-wrap">Service Name</th>
            <th class="no-wrap">Category Name</th>
            <th>Price</th>
            <th>Description</th>
            <th class="no-wrap">Time Slots</th>
            <th>Image</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody v-if="services.length > 0">
          <tr v-for="(item, index) in services" :key="item.id">
            <td>{{ index + 1 }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.serviceCategoryId.name }}</td>
            <td class="no-wrap">PHP {{ item.price.toFixed(2) }}</td>
            <td>{{ item.description }}</td>
            <td>
              <template>
                <div class="time">
                  <datepicker
                  :use-utc="true"
                  :disabled-dates="getDisabledDates(item.timeSlot)"
                  :inline="true"
                  ></datepicker>
                </div>
              </template>
            </td>
            <td><img :src="item.image" :alt=item.category_name style="width: 200px; height: 150px;"></td>
            <td>
              <span @click="showEditService({id: item.id, index: index})" class="btn btn-warning service_category_edit_btn">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-pen-fill" viewBox="0 0 16 16">
                  <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001z"/>
                </svg>
              </span>
            </td>
          </tr>
        </tbody>
        <tbody v-else>
          <tr><td colspan="8">There is nothing to show in this table.</td></tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import Datepicker from 'vuejs-datepicker';
export default {
  name: 'ServiceList',
  data(){
    return {
      showPage: 'ServicePage', // Initialize showPage to ServicePage
      newServiceData: {},
      updateServiceData: {},
      services: [],
      modalId: 'customModal',
    };
  },
  components: { 
    Datepicker,
  },
  props: {
    new_time_slot: {
      type: Object,
      validator: function(value) {
        if (value.time_slot) console.log('ServiceList, new timeslot with value: ', value);
        // Return true to disable type checking
        return true;
      },
    },
    new_service: {
      type: Array,
      validator: function(value) {
        if (value.id) console.log('this is from servicePage to serviceList, the new service is: ', value);
        // Return true to disable type checking
        return true;
      },
    },
    update_service: {
      type: Object,
      validator: function(value) {
        if (value.service_details) console.log('this is from servicePage to serviceList, the update service is: ', value);
        // Return true to disable type checking
        return true;
      },
    },
  },
  methods: {
    getDisabledDates(dates) {
      let enabledDates = [];

      for (const date of dates) {
        const from = this.formatDate(date.startDate);
        const to = this.formatDate(date.endDate);

        // Create an array of dates between 'from' and 'to'
        const currentDate = new Date(from);
        while (currentDate <= new Date(to)) {
          enabledDates.push(currentDate.toISOString().split('T')[0]);
          currentDate.setDate(currentDate.getDate() + 1);
        }
      }

      return {
        customPredictor: date => {
          const formattedDate = date.toISOString().split('T')[0];
          return !enabledDates.includes(formattedDate);
        },
      };
    },
    formatDate(dateToParse) {
      const dateComponents = dateToParse.split('-');
      const year = parseInt(dateComponents[0]);
      const month = parseInt(dateComponents[1]) - 1;
      const day = parseInt(dateComponents[2]);
      const jsDate = new Date(year, month, day + 1);
      return jsDate;
    },
    async get_services() {
      try {
        const response = await this.$apollo.query({ query: require('@/graphql/AdminService.gql'), });
        this.services = response.data.serviceAdmin
        console.log('all services: ', response);

        if (this.newServiceData.id) this.merge_new_service_to_services(this.services)
        if (this.updateServiceData.service_details) this.update_service_list(this.services)
        if (this.new_time_slot.time_slot) {
          this.services[this.new_time_slot.index_to_edit].timeSlot = this.new_time_slot.time_slot;
          console.log('ServiceList/get_services:124', this.services[this.new_time_slot.index_to_edit].timeSlot);
        } 
        console.log('ServiceList/get_services: new_time_slot.index_to_edit: ', this.new_time_slot.index_to_edit, this.new_time_slot.time_slot);
      } catch (error) {
        console.log('Error from get_services: ', error);
      }
    },
    update_service_list(service) {
      let service_one = service[this.updateServiceData.index_to_edit];
      console.log('servicelist: the edited service is: ', service_one);
      service_one['image'] = this.updateServiceData.service_details.image;
      service_one['name'] = this.updateServiceData.service_details.name;
      service_one['price'] = this.updateServiceData.service_details.price;
    },
    merge_new_service_to_services(all_service) {
      let newservice = {
        description: this.newServiceData.description,
        id: this.newServiceData.id,
        image: this.newServiceData.image,
        name: this.newServiceData.name,
        serviceCategoryId: {
          id: this.newServiceData.service_category,
          name: this.newServiceData.service_categories[0].name
        },
        timeSlot: [],
      }
      all_service.push(newservice)
    },
    showEditService(params) {
      console.log('serviceList: the service id to edit is: ', params['id'])
      this.$emit('showEditService', params);
    },
    showServiceNew() {
      this.$emit('showServiceNew'); // Emit a custom event
    },
  },
  mounted() {
    this.get_services();
    // Assign the prop value to the data property
    if (this.new_service) {
      this.newServiceData = this.new_service;
      console.log('this is from servicepage to servicelist, new service data is: ', this.newServiceData);
    } 
    if (this.update_service) {
      if (this.update_service.service_details) {
        this.updateServiceData = this.update_service;
        console.log('this is from servicepage to servicelist, update service data is: ', this.updateServiceData);
      }
    }
  },  
  created() {
    if (this.new_time_slot) {
      if (this.new_time_slot.index_to_edit) {
        console.log('Props received: new_time_slot: ', this.new_time_slot);
        this.services[this.new_time_slot.index_to_edit].timeSlot = this.new_time_slot.time_slot;
      }
    }
  }
}
</script>

<style>
@import 'vue2-timepicker/dist/VueTimepicker.css';
.time {
  display: inline-block;
  white-space: wrap; 
}

.error, .error:focus, .error input[type="radio"] {
    border-color: red;
    color: red;
}

.input-errors {
    color: red;
}

.err-card {
    position: relative;
}

.error-msg {
    position: absolute;
    font-size: 10px;
    bottom: -8px;
    left: 17px;
}
</style>