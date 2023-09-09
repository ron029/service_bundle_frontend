<template>
  <div class="container">
    <div v-if="userRole === 'admin'">
      <ServiceList />
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
  data() {
    return {
      userRole: '',
      service_category_id: ''
    };
  },
  name: 'ServicePage',
  components: {
    ServiceList,
    ServiceListCustomer,
    // ServiceListManager
  },
  mounted() {
    this.userRole = this.get_role();

  },
  methods: {
    get_role() {
      const userRole = localStorage.getItem('userRole');
      return userRole;
    }
  }
}
</script>

<style>

</style>
