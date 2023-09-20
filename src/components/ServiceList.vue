<template>
  <div>
    <h2>Services</h2>
    <button @click="showServiceNew">Show ServiceNew</button>
      <table class="table">
        <thead>
          <tr>
            <th>No.</th>
            <th>Service Name</th>
            <th>Category Name</th>
            <th>Price</th>
            <th>Description</th>
            <th>Time Slots</th>
            <th>Image</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in services" :key="item.id">
            <td>{{ index + 1 }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.serviceCategoryId.name }}</td>
            <td>PHP {{ item.price.toFixed(2) }}</td>
            <td>{{ item.description }}</td>
            <td>
              <template>
                <div class="time">
                  <datepicker
                  :disabled-dates="getDisabledDates(item.timeSlot)"
                  :inline="true"
                  ></datepicker>
                </div>
              </template>
            </td>
            <td><img :src="item.image" :alt=item.category_name style="width: 200px; height: 150px;"></td>
            <td>
              <span class="btn btn-warning" @click="showEditService({id: item.id, index: index})">Edit</span>
              <!-- <router-link :to="{ path: '/services/' + item.id + '/edit' }" class="btn btn-warning"> Edit </router-link> -->
            </td>
          </tr>
        </tbody>
      </table>
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
    };
  },
  components: { Datepicker, },
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
      const jsDate = new Date(year, month, day);
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
      // const category = this.newServiceData.service_categories.find(
      //   (category) => category.id === this.newServiceData.service_category
      // );
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
  mounted(){
    this.get_services();
    // Assign the prop value to the data property
    if (this.new_service) {
      this.newServiceData = this.new_service;
      console.log('this is from servicepage to servicelist, new service data is: ', this.newServiceData);
    } 
    if (this.update_service.service_details) {
      this.updateServiceData = this.update_service;
      console.log('this is from servicepage to servicelist, update service data is: ', this.updateServiceData);
    }
  },
  created() {
    if (this.new_time_slot.index_to_edit) {
      console.log('Props received: new_time_slot: ', this.new_time_slot);
      this.services[this.new_time_slot.index_to_edit].timeSlot = this.new_time_slot.time_slot;
    }
  }
}
</script>

<style>
/* @import 'vuejs-datepicker/dist/vuejs-datepicker.css'; */
@import 'vue2-timepicker/dist/VueTimepicker.css';
.time {
  display: inline-block;
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