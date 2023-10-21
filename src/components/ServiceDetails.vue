<template>
  <div class="container">
    <div class="jumbotron">
      <video autoplay loop muted>
        <source src="https://res.cloudinary.com/dovxq5gn9/video/upload/v1696256736/xvwogy_1_bmk2b2.mp4" type="video/mp4" />
      </video>

      <div class="text-content">
        <h1 class="display-4 service_category_title_home">Welcome to Service Bundle</h1>
        <p class="lead">Discover, Book, and Experience the Best Local Services Near You</p>
        <hr class="my-4">
        <p>With Service Bundle, you're just a few taps away from enjoying top-notch services at your preferred time and location. We've simplified the way you book appointments, so you can focus on what truly matters – pampering yourself and looking your best!</p>
      </div>
    </div>
    <datepicker 
    calendar-class="day"
    :day-cell-content="params => format_date(params)"
    :inline="true"
    :bootstrap-styling="true"
    ></datepicker>
  </div>
</template>

<script>
import Datepicker from 'vuejs-datepicker';
export default {
  name: 'ServiceDetails',
  components: { Datepicker, },
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
    format_date(params) {
      return `<span class='day-content'>${params.date}</span>`
    }
  }
}
</script>

<style>
.vdp-datepicker__calendar {
  width: 100%;
}

.day .day-content {
  border: 1px solid blue;
  border-radius: 15px;
  padding: 7px;
  width: 50px;
}
</style>
