<template>
  <div class="container">
    <div v-if="userRole === 'admin'">
      <ServiceList  
      v-on:showServiceNew="showServiceNewPage()" 
      v-on:showEditService="showEditPage($event)"
      :new_service="newServiceData"
      :update_service="updateServiceData"
      :new_time_slot="updateServiceTimeSlotData"
      />
    </div>
    <div v-if="userRole === 'customer'">
      <ServiceListCustomer />
    </div>
    <div v-if="userRole === 'manager'">
      <ServiceList />
    </div>
  </div>
</template>

<script>
// import ServiceListManager from '@/components/ServiceListManager.vue';
import ServiceListCustomer from '@/components/ServiceListCustomer.vue';
import ServiceList from '@/components/ServiceList.vue';
export default {
  name: 'ServicePage',
  data() {
    return {
      userRole: '',
      service_category_id: '',
      newServiceData: {},
      updateServiceData: {},
      updateServiceTimeSlotData: {}
    };
  },
  created() {
    // Assign the prop value to the data property
    if (this.new_service_data) this.newServiceData = this.new_service_data;
    if (this.update_service_data) this.updateServiceData = this.update_service_data;
    if (this.update_service_time_slot_data) this.updateServiceTimeSlotData = this.update_service_time_slot_data;
  },
  components: {
    ServiceList,
    ServiceListCustomer,
    // ServiceListManager
  },
  mounted() {
    this.userRole = this.get_role();
    this.validate_new_service(this.new_service_data);
    this.validate_update_service(this.update_service_data)
  },
  props: {
    update_service_time_slot_data: {
      type: Object,
      validator: function(value) {
        console.log('ServicePage: new timeslot added: ', value);
        // Return true to disable type checking
        return true;
      },
    },
    new_service_data: {
      type: Array,
      validator: function(value) {
        console.log('this is from appnavbar to service page, the new service is: ', value);
        // Return true to disable type checking
        return true;
      },
    },
    update_service_data: {
      type: Object,
      validator: function(value) {
        console.log('this is from appnavbar to service page, the new service is: ', value);
        // Return true to disable type checking
        return true;
      },
    }
  },
  methods: {
    showEditPage(params) {
      console.log('the params are: ', params.id, params.index)
      this.$emit('showEditPage', params);
      console.log('this is service page, the service id to edit is: ', params.id);
    },
    showServiceNewPage() {
      this.$emit('showServiceNew'); // Emit a custom event
    },
    get_role() {
      const userRole = localStorage.getItem('userRole');
      return userRole;
    },
    validate_new_service(data){
      if (data) {
        console.log('servicePage: the newly service that added is: ', data);
      }
    },
    validate_update_service(data) {
      if (data) {
        console.log('servicePage: the updated service that added is: ', data);
      }
    }
  }
}
</script>

<style>

</style>
