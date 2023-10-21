<template>
  <div class="container-fluid">
    <BookList v-if="userRole === 'admin' || userRole === 'manager'"/>
  </div>
</template>

<script>
import BookList from '@/components/BookList.vue';
export default {
  data() {
      return {
        userRole: '',
      }
  },
  name: 'BookingPage',
  components: {
    BookList,
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
