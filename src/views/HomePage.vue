<template>
  <div class="container">
    <CustomerPage v-if="userRole === 'customer'" />
  </div>
</template>

<script>
import CustomerPage from '@/components/CustomerPage.vue';

export default {
  components: {
    CustomerPage
  },
  data() {
    return {
      userRole: ''
    };
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
};
</script>

<style>

</style>
