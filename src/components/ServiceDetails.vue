<template>
  <div class="container">
    <div class="jumbotron">
      <img class="service-image-one" :src="data.image" />

      <div class="text-content-service-details">
        <h1 class="display-4 service_category_title_home">{{ data.name}}</h1>
        <hr class="my-4">
        <p>{{ data.description }}</p>
      </div>
    </div>
    <div v-if="err_notif" class="alert alert-danger alert-dismissible fade show" role="alert">
      {{ err_message }} <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <div class="row">
      <div class="col-md-6">
        <p class="pick-date-msg">Pick the Date That Works for You</p>
        <datepicker
          class="time"
          :use-utc="true"
          :disabled-dates="getDisabledDates(data.timeSlot)"
          :day-cell-content="params => format_date(params)"
          :inline="true"
          @selected="params => handleDateSelected(params, data)"
        ></datepicker>
      </div>
      <div class="col-md-6 hidden-sm hidden-xs service_list_customer_timeslot">
        <div class="offcanvas_timeslot_info">
          <h1 v-if="displayService != ''">{{ displayService }}</h1>
          <form @submit.prevent="submitForm" class="form-slot-picker">
            <div v-if="open_time == false">
              <p>Duration: {{ duration }}</p>
              <p>Available Slot: {{ slot }}</p>
              <div v-if="time == '' && available_timeslot.length > 0">
                <p>Available timeslot:</p>
                <div class="scrollable-container">
                  <div class="scrollable-list">
                    <div v-for="(timeOption, index) in available_timeslot" :key="index">
                      <label class="radio-label">
                        <input
                          type="radio"
                          :value="timeOption.value"
                          v-model="time"
                          name="timeOption"
                          class="radio-input"
                        />
                        {{ timeOption.label }}
                      </label>
                    </div>
                  </div>
                </div>
              </div>
              <div v-else-if="time == '' && available_timeslot.length <= 0">
                <p v-if="maxTime != ''">No open time slots on this day.</p>
                <p v-else>Select a date for your appointment.</p>
              </div>
              <div v-else>
                <p @click.prevent="changeTime">Selected Time: {{ time }}</p>
              </div>
            </div>
            <div v-else>
              <p>Available Slot: {{ slot > 50 ? 50 : slot }}</p>
              <p v-if="minTime != '' && maxTime != ''">Select time from {{ minTime }} to {{ maxTime }}</p>
              <vue2-timepicker
                v-model="time"
                :hour-range="[[startHour(),endHour()]]"
                lazy
                hide-clear-button
                @change="onTimeSelected()"
              />
              <p v-if="time != ''">Selected Time: {{ time }}</p>
            </div>
            <input v-if="time != ''" type="submit" value="submit">
          </form>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import { required, helpers } from '@vuelidate/validators';
import { useVuelidate } from '@vuelidate/core'
import Datepicker from 'vuejs-datepicker';
import Vue2Timepicker from 'vue2-timepicker';
export default {
  name: 'ServiceDetails',
  setup () { return { v$: useVuelidate() } },
  components: { 
    Datepicker,
    Vue2Timepicker,
  },
  data() {
    return {
      timeslot: [],
      data: [],
      date_checked: false,
      minTime: '',
      maxTime: '',
      duration: '',
      time: '',
      available_timeslot: [],
      date: '',
      service: '',
      displayService: '',
      open_time: false,
      slot: 0,
      err_message: '',
      err_notif: false,
    }
  }, 
  validations() {
    const min_time = value => {
      const selectedTime = new Date(`1970-01-01T${this.convertTo24HourFormat(value)}`);
      console.log('min_time val: ', value, this.minTime)
      const mintime = new Date(`1970-01-01T${this.convertTo24HourFormat(this.minTime)}`);
      console.log('min_time result: ', selectedTime >= mintime)
      return selectedTime >= mintime;
    };
    const max_time = value => {
      const selectedTime = new Date(`1970-01-01T${this.convertTo24HourFormat(value)}`);
      console.log('max_time val: ', value, this.maxTime)
      const maxtime = new Date(`1970-01-01T${this.convertTo24HourFormat(this.maxTime)}`);
      console.log('max_time result: ', selectedTime <= maxtime)
      return selectedTime <= maxtime;
    };
    return {
      time: {
        required,
        // validTime(value) {
        //   const timePattern = /^([01]\d|2[0-3]):([0-5]\d)$/;
        //   return timePattern.test(value);
        // },
        min_time: helpers.withMessage('The min time must be ' + this.minTime, min_time) ,     
        max_time: helpers.withMessage('The max time must be ' + this.maxTime, max_time) ,     
      },
    }
  },
  methods: {
    handleError(errMsg) {
      this.err_message = errMsg;
      this.err_notif = true;
      setTimeout(() => this.err_notif = false, 10000);
    },
    isTimeInFormat() {
      const timePattern = /^(0[1-9]|1[0-2]):[0-5][0-9]:[0-5][0-9] (AM|PM)$/;
      return timePattern.test(this.time);
    },
    onTimeSelected() {
      this.time = this.convertTo12HourFormat(this.time);
    },
    async create_cart_item() {
      try {
        const date = this.date;
        const service_id = this.service.id;
        const time = this.time;
        console.log('serviceid is ', service_id)
        console.log('date ', date);
        console.log('time ', time)

        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/CartItemCreate.gql'),
          variables: {
            serviceId: service_id,
            date: date,
            time: time,
          },
        });
        console.log('response from server create cart item',response);
        if (response.data.createCartItem.errors.length < 1) {
          alert('Item added to the cart successfully!');
          // this.$router.push('/cart')
        } else {
          this.handleError(response.data.createCartItem.errors[0]);
        }
      } catch (error) {
        console.error('Error in create_cart_item:', error);
        // Handle the error here, e.g., show an error message to the user.
      }
    },
    convertTo24HourFormat(time12) {
      // Split the input time into hours, minutes, and AM/PM parts
      const [timePart, ampm] = time12.split(' ');
      const [hours, minutes, seconds] = timePart.split(':');

      // Parse the hours as an integer
      let convertedHours = parseInt(hours, 10);

      // Adjust the hours based on AM or PM
      if (ampm.toUpperCase() === 'PM' && convertedHours !== 12) {
        convertedHours += 12;
      } else if (ampm.toUpperCase() === 'AM' && convertedHours === 12) {
        convertedHours = 0;
      }
      // Create the 24-hour format time string
      const convertedTime = `${String(convertedHours).padStart(2, '0')}:${minutes}:${seconds}`;

      return convertedTime;
    },
    convertTo12HourFormat(time24) {
      const [hours, minutes] = time24.split(":");
      let ampm = "AM";
      let convertedHours = parseInt(hours, 10);
      if (convertedHours >= 12) {
        ampm = "PM";
        if (convertedHours > 12) {
          convertedHours -= 12;
        }
      } else if (convertedHours === 0) {
        convertedHours = 12; // Midnight in 12-hour format is 12:00 AM
      }
      const new_time = `${String(convertedHours).padStart(2, "0")}:${minutes}:00 ${ampm}`;
      return new_time;
    },
    async submitForm() {
      this.minTime = this.convertTo12HourFormat(this.minTime);
      this.maxTime = this.convertTo12HourFormat(this.maxTime);
      this.v$.time.$touch();
      if (this.v$.$error) {
        console.log('error');
        console.log('error time: ', this.time);
        console.log('errormsg: ', this.v$.$errors);
      } else {
        await this.create_cart_item();
      }
      this.minTime = this.convertTo24HourFormat(this.minTime);
      this.maxTime = this.convertTo24HourFormat(this.maxTime);
      const time24 = this.time.trim();
      if (time24.match(/^\d{2}:\d{2}$/)) {
        this.convertedTime = this.convertTo12HourFormat(time24);
      }
      console.log('UPDATED TIME: ',this.convertedTime);
    },
    startHour(){
      if (this.date == this.dateToday()) {
        const hour = this.getCurrentHour();
        if (hour >= parseInt(this.minTime.split(":")[0], 10)) return hour + 1;
      } else {
        return parseInt(this.minTime.split(":")[0], 10);
      }
    },
    endHour(){
      return parseInt(this.maxTime.split(":")[0], 10);
    },
    disable_date_by_slot_func() {
      // console.log('DISABLE DATE BY SLOT FUNC ')
      const service_category = [this.data];
      let disable_date_by_slot = [];

      for (let i = 0; i < service_category.length; i++) {
        for (let j = 0; j < service_category[i].cartItemTally.length; j++) {
          // Use findDateRangeIndex to check if the date is in the range
          let index = this.findDateRangeIndex(service_category[i].timeSlot, service_category[i].cartItemTally[j].date);
          if (index !== -1) {
            // console.log('the date: ', service_category[i].cartItemTally[j].date, ' found in ', service_category[i].timeSlot[index].startDate,service_category[i].timeSlot[index].endDate)
            let capacity = service_category[i].timeSlot[index].capacity;
            // console.log('capacity >= service_category[i].cartItemTally[j].count',capacity >= service_category[i].cartItemTally[j].count,capacity,service_category[i].cartItemTally[j].count)
            if (service_category[i].cartItemTally[j].count >= capacity) disable_date_by_slot.push(service_category[i].cartItemTally[j].date);
          }
        }
      }
      console.log('disable_date_by_slot: ',disable_date_by_slot)
      return disable_date_by_slot;
    },
    format_date(params) {
      return params.date
    },
    formatLongDate(dateString) {
      const dateObject = new Date(dateString);

      // Get the year, month, and day components
      const year = dateObject.getFullYear();
      const month = (dateObject.getMonth() + 1).toString().padStart(2, "0"); // Adding 1 because months are 0-based
      const day = dateObject.getDate().toString().padStart(2, "0");

      // Create the "YYYY-MM-DD" formatted date string
      return `${year}-${month}-${day}`;
    },
    getCurrentHour() {
      const currentDate = new Date();
      const currentHour = currentDate.getHours();

      return parseInt(currentHour);
    },
    dateToday() {
      // Create a Date object with the desired date (e.g., the current date)
      const currentDate = new Date();

      // Get the day, month, and year components
      const day = currentDate.getDate(); // 1-31
      const month = currentDate.getMonth() + 1; // 0-11 (January is 0, so add 1)
      const year = currentDate.getFullYear(); // 4-digit year
      const formattedDay = String(day).padStart(2, '0');
      const formattedMonth = String(month).padStart(2, '0');
      return `${year}-${formattedMonth}-${formattedDay}`;
    },
    parseTime(timeStr) {
      const [hours, minutes] = timeStr.split(':').map(Number);
      const date = new Date();
      date.setHours(hours, minutes, 0, 0);
      return date;
    },
    createAvailableTimeSlot(start_time_str, end_time_str, duration, interval, date_selected, item) {
      const date_selected_formatted = this.formatLongDate(date_selected);
      const hour = this.getCurrentHour();
      let edited_start_time = 0;
      if (this.dateToday() == date_selected_formatted) {
        const timeComponents = start_time_str.split(":");
        // Extract the hour component (the first element after splitting)
        const selectedHour = parseInt(timeComponents[0], 10);
        if (hour >= selectedHour) {
          console.log(hour >= start_time_str, 'HOUR')
          edited_start_time = `${hour + 1}:00:00`;
        }
      }
      console.log('edited_start_time',edited_start_time)
      console.log(this.dateToday() == date_selected_formatted,this.dateToday(),date_selected_formatted)
      if (duration == null) duration = 0;
      const availableTimeSlots = [];
      const startTime = edited_start_time == 0 ? this.parseTime(start_time_str) : this.parseTime(edited_start_time);
      console.log('startTime: ', startTime, 'this.parseTime(start_time_str): ', this.parseTime(start_time_str))
      const endTime = this.parseTime(end_time_str);

      let currentTime = new Date(startTime);

      while (currentTime <= endTime) {
        availableTimeSlots.push({value: this.formatTime(currentTime), label: this.formatTime(currentTime)});
        currentTime = this.addMinutes(currentTime, duration); // Increment by duration, not interval
        currentTime = this.addMinutes(currentTime, interval); // Add the remaining interval
      }
      
      const dateObject = new Date(date_selected);
      let new_timeslot = [];
      // Format it as a date string
      const formattedDate = dateObject.toISOString().split('T')[0];
      for (let i=0; i<item.length; i++) {
        if (item[i].date == formattedDate) {
          const dateObject = new Date(item[i].time);

          // Format it as a time string
          // Create an Intl.DateTimeFormat object with the desired time zone
          const formatter = new Intl.DateTimeFormat('en-US', {
            hour: 'numeric',
            minute: 'numeric',
            second: 'numeric',
            timeZone: 'UTC' // Set the desired time zone
          });

          // Format the date object
          const timeString = formatter.format(dateObject);
          new_timeslot = availableTimeSlots.filter(item => item.value !== timeString);
        }
      }
      console.log('available timeslot: ', availableTimeSlots);      
      console.log('new_timeslot',new_timeslot)
      return new_timeslot.length > 0 ? new_timeslot : availableTimeSlots;
    },
    addMinutes(time, minutes) {
      return new Date(time.getTime() + minutes * 60000);
    },
    formatTime(time) {
      return time.toLocaleTimeString('en-US', { hour12: true });
    },
    findDateRangeIndex(dateRanges, targetDate) {
      const date = new Date(targetDate); // Convert targetDate to a Date object
      for (let i = 0; i < dateRanges.length; i++) {
        const { startDate, endDate } = dateRanges[i];

        if (date >= new Date(startDate) && date <= new Date(endDate)) {
          return i; // Return the index if the date is within the range
        }
      }
      return -1; // Return -1 if the date is not found in any range
    },
    handleDateSelected(params, item) {
      let range = item.timeSlot[this.findDateRangeIndex(item.timeSlot, params)];
        // console.log('timeslot info is: ', range);
      this.minTime = range.startTime;
      this.maxTime = range.endTime;
      this.duration = range.duration;
      console.log('range: ',range);

      let booked_counter = 0;
      for (let i=0; i<item.cartItem.length; i++) {
        if(this.formatLongDate(params) == item.cartItem[i].date) booked_counter++;
      }
      this.slot = range.capacity - booked_counter;
      console.log('remaining slot for date: ',this.formatLongDate(params), ' is: ', this.slot)

      if (range.duration !== null) {
        this.open_time = false;
        this.time = '';
        this.available_timeslot = this.createAvailableTimeSlot(range.startTime, range.endTime, range.duration, range.interval, params, item.cartItem)
      } else {
        this.open_time = true;
      }
      // This method will be called when a date is selected
      this.date = params;
      this.service = item;
      console.log('Selected date:', params, item);
    },
    getDisabledDates(dates) {
      if (dates === undefined) return;
      
      console.log('the dates: ', dates)
      let enabledDates = [];
      const today = new Date(); // Get today's date as a Date object

      for (const date of dates) {
        const from = new Date(date.startDate); // Convert to Date object
        const to = new Date(date.endDate); // Convert to Date object

        // Create an array of dates within the 'from' and 'to' range
        const currentDate = new Date(from);
        while (currentDate <= to) {
          enabledDates.push(currentDate.toISOString().split('T')[0]);
          currentDate.setDate(currentDate.getDate() + 1);
        }
      }

      const disable_date_by_slot = this.disable_date_by_slot_func();

      return {
        customPredictor: date => {
          const formattedDate = date.toISOString().split('T')[0]; // Convert date to a string
          // Disable past days
          if (date < today) return true;

          if (this.date_checked == false) {
            if (disable_date_by_slot.includes(formattedDate)) {
              this.date_checked == true;
              return true;
            }
          }
          // Enable today's date and dates within the specified date range
          return !enabledDates.includes(formattedDate);
        },
      };
    },
    async get_service() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/ServiceFind.gql'),
          variables: { id: parseInt(this.$route.params.serviceId)}
        });
        this.data = response.data.service[0];
        this.displayService = response.data.service[0].name;
        console.log('service_data', this.data);
      } catch (error) {
        console.error('Error creating like:', error);
      }
    },
  },
  mounted() {
    this.get_service();
  }
}
</script>

<style>
.service-image-one {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.pick-date-msg {
  margin-top: 15px;
}

.text-content-service-details {
  color: #ddd;
  height: 400px;
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  padding: 20px;
  background-color: rgba(31, 28, 28, 0.493);
  z-index: 3;
}

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
