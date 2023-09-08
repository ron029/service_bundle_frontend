<template>
  <div class="">
      <h2>Bookings</h2>
      <BookList v-if="userRole === 'admin'"/>
      <BookListManager v-if="userRole === 'manager'"/>
  </div>
</template>

<script>
import BookList from '@/components/BookList.vue';
import BookListManager from '@/components/BookListManager.vue';
export default {
  data() {
      return {
        userRole: '',
      }
  },
  name: 'BookingPage',
  components: {
    BookList,
    BookListManager
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
