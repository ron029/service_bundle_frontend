<template>
  <div>
    <h1>TimeSlot Details</h1>
    <p>Category Name: {{ this.$route.params.categoryId }}</p>
    <p>Service Name: {{ this.$route.params.serviceId }}</p>
    <p>Time Slot: {{ this.$route.params.timeSlotId }}</p>
    <p>Choose time between {{  this.service.start_time }} and {{   this.service.end_time }}</p>
    <p v-if="service.date == getCurrentDate()">You're about to select the date today ({{ this.service.date }}), please select the time in the future.</p>
    <form @submit.prevent="submitForm">
      <input type="time" v-model="service.time">
      <input type="submit">
    </form>
  </div>
</template>

<script>
export default {
  name: 'TimeSlotDetails',
  data() {
    return {
      service: {
        time: '',
        start_time: '',
        end_time: '',
        date: ''
      }
    }
  },
  methods: {
    getCurrentDate() {
      const currentDate = new Date();
      currentDate.setDate(currentDate.getDate() + 1); // Add one day
      // Format the date as needed, e.g., "YYYY-MM-DD"
      const formattedDate = currentDate.toISOString().split('T')[0];
      return formattedDate;
    },
    async submitForm(){
      await this.create_cart_item();
    },
    async create_cart_item() {
      try {
        const date = await this.fetch_time_slot()
        const service_id = this.$route.params.serviceId;
        const time = this.service.time
        console.log('serviceid is ', service_id)
        console.log('date ', date);
        console.log('time ', time)

      const response = await this.$apollo.mutate({
        mutation: require('@/graphql/CartItemCreate.gql'),
        variables: {
          serviceId: service_id,
          date: this.$route.query.date,
          time: time,
        },
      });
      console.log(response);
      if (response.data.createCartItem.errors < 1) {
        alert('SUCCESS !')
        this.$router.push('/cart')
      }
    } catch (error) {
      console.error('Error in create_cart_item:', error);
      // Handle the error here, e.g., show an error message to the user.
    }
    },
    async fetch_time_slot(){
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/TimeSlotOne.gql'),
          variables: { id: parseInt(this.$route.params.timeSlotId)}
        });
        this.service.start_time = await this.formattedStartTime(response.data.timeSlotOne.startTime);
        this.service.end_time = await this.formattedStartTime(response.data.timeSlotOne.endTime);
        this.service.date = await response.data.timeSlotOne.date;
        console.log(response)
        return response.data.timeSlotOne.date;

      } catch (error) {
        console.error('Error in fetch_time_slot:', error);
      }
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
    },
  },
  mounted(){
    this.fetch_time_slot()
  },    
}
</script>

<style>

</style>
