<template>
  <div class="container">
    <!-- <div class="tooltip_custom">Hover over me
      <span class="tooltiptext_custom">Tooltip text</span>
    </div> -->
    <!-- <h1>Services</h1> -->
    <!-- <button @click="openModal">Open Modal</button>
    <button id="toggleButton">Toggle Offcanvas</button> -->
    <!-- Use the Modal component -->
    <ModalTest :modalId="modalId">
      <!-- Customize the content using slots -->
      <template v-slot:header>Custom Modal Header</template>
      <template v-slot:body>Custom Modal Body</template>
      <template v-slot:footer>
        <button type="button" class="btn btn-secondary" @click="closeModal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </template>
    </ModalTest>
    <div v-if="err_notif" class="alert alert-danger alert-dismissible fade show" role="alert">
      {{ err_message }} <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <div class="row service_list_customer">
      <div class="col-md-6 service_list_customer_services">
        <div v-for="(item,index) in service_by_category" :key="index" class="">
          <div class="card service_box">
            <div class="row card-body service_item" @click="showService(item)">
              <!-- <a class="service_link" :href="generate_service_link(item.id)"> -->
              <h5>{{ item.name }}</h5>
              <div class="col-md-4">
                <img v-if="calendar" class="service_image" :src="item.image">
                <img v-else class="service_image_whole" :src="item.image">
                <!-- <p class="service_details" v-if="!calendar">{{ item.description }}</p> -->
                <p class="service_details" v-if="!calendar">{{ formatToPHP(item.price) }}</p>
              </div>
              <!-- </a> -->
              <div class="col-md-8" v-if="calendar">
                <!-- :style="showTimeslotIndex === index ? 'display: block;' : 'display: none;'" -->
                <datepicker
                  class="time"
                  :use-utc="true"
                  :disabled-dates="getDisabledDates(item.timeSlot)"
                  :day-cell-content="params => format_date(params)"
                  :inline="true"
                  @selected="params => handleDateSelected(params, item)"
                ></datepicker>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-6 hidden-sm hidden-xs service_list_customer_timeslot">
        <div class="offcanvas_timeslot_info">
          <h1 v-if="displayService != ''">{{ displayService }}</h1>
          <form @submit.prevent="submitForm">
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
import ModalTest from '@/components/ModalTest.vue';
import Datepicker from 'vuejs-datepicker';
import Vue2Timepicker from 'vue2-timepicker';
export default {
  name: 'ServiceListCustomer',
  setup () { return { v$: useVuelidate() } },
  data() {
    return {
      service_by_category: [],
      modalId: 'customModal',
      available_timeslot: [],
      duration: 0,
      date: '',
      open_time: false,
      minTime: 0,
      maxTime: 0,
      time: '',
      convertedTime: '',
      service_id: '',
      service: [],
      slot: 0,
      err_message: '',
      err_notif: false,
      date_checked: false,
      calendar: true,
      showCalendarIndex: 0,
      displayService: '',
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
  components: {
    Datepicker,
    ModalTest,
    Vue2Timepicker,
  },
  methods: {
    showService(item) {
      this.displayService = item.name
      history.pushState(
        {},
        null,
        this.$route.path + '/services/' + encodeURIComponent(item.id)
      )
    },
    showCalendar(index) {
      this.calendar = true;
      this.showCalendarIndex = index;
      console.log('showCalendar', index);
    },
    hideCalendar() {
      this.calendar = false;
      console.log('hide calendar')
    },
    isTimeInFormat() {
      const timePattern = /^(0[1-9]|1[0-2]):[0-5][0-9]:[0-5][0-9] (AM|PM)$/;
      return timePattern.test(this.time);
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
          alert('SUCCESS !')
          // this.$router.push('/cart')
        } else {
          this.handleError(response.data.createCartItem.errors[0]);
        }
      } catch (error) {
        console.error('Error in create_cart_item:', error);
        // Handle the error here, e.g., show an error message to the user.
      }
    },
    handleError(errMsg) {
      this.err_message = errMsg;
      this.err_notif = true;
      setTimeout(() => this.err_notif = false, 10000);
    },
    onTimeSelected() {
      this.time = this.convertTo12HourFormat(this.time);
    },
    changeTime() { this.time = '' },
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
    getCurrentHour() {
      const currentDate = new Date();
      const currentHour = currentDate.getHours();

      return parseInt(currentHour);
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
    handleDateSelected(params, item) {
      let range = item.timeSlot[this.findDateRangeIndex(item.timeSlot, params)];
        // console.log('timeslot info is: ', range);
      this.minTime = range.startTime;
      this.maxTime = range.endTime;
      this.duration = range.duration;
      console.log('range: ',range);
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
    format_date(params) {
      return params.date
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
    parseTime(timeStr) {
      const [hours, minutes] = timeStr.split(':').map(Number);
      const date = new Date();
      date.setHours(hours, minutes, 0, 0);
      return date;
    },
    formatTime(time) {
      return time.toLocaleTimeString('en-US', { hour12: true });
    },
    addMinutes(time, minutes) {
      return new Date(time.getTime() + minutes * 60000);
    },
    handleScroll(event) {
      const element = event.target;
      const scrollSpeed = 100; // Adjust this value to control scrolling speed

      if (event.deltaY !== 0) {
        // Prevent vertical scrolling
        event.preventDefault();

        // Calculate the horizontal scroll amount based on scroll speed and scroll direction
        const scrollAmount = event.deltaY > 0 ? scrollSpeed : -scrollSpeed;

        // Scroll horizontally
        element.scrollLeft += scrollAmount;
      }
    },
    openModal() {
      // Use JavaScript to open the modal
      const modal = document.getElementById(this.modalId);
      modal.classList.add('show');
      modal.style.display = 'block';
      modal.setAttribute('aria-hidden', 'false');

      const modalBackdrop = document.createElement('div');
      modalBackdrop.classList.add('modal-backdrop', 'fade', 'show');
      document.body.appendChild(modalBackdrop);
    },
    closeModal() {
      const modal = document.getElementById(this.modalId);
      modal.classList.remove('show');
      modal.style.display = 'none';
      modal.setAttribute('aria-hidden', 'true');

      const modalBackdrop = document.querySelector('.modal-backdrop');
      modalBackdrop.remove();
    },
    generate_service_link(service_id) {
      return `/service_categories/${this.$route.params.categoryId}/services/${service_id}`;
    },
    formatToPHP(number) {
      // Convert the number to a string with two decimal places
      const formattedNumber = Number(number).toFixed(2);

      // Add "PHP " to the formatted number and use commas as a thousands separator
      const result = `PHP ${formattedNumber.replace(/\B(?=(\d{3})+(?!\d))/g, ', ')}`;

      return result;
    },
    timestampTodate(timestamp) {
      const date = new Date(timestamp);
      // Extract the components (month, day, year)
      const month = (date.getMonth() + 1).toString().padStart(2, '0'); // Add 1 because months are zero-indexed
      const day = date.getDate().toString().padStart(2, '0');
      const year = date.getFullYear();

      // Format the date as MM-DD-YYYY
      return `${year}-${month}-${day}`;
    }, 
    getDisabledDates(dates) {
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
    disable_date_by_slot_func() {
      // console.log('DISABLE DATE BY SLOT FUNC ')
      const service_category = this.service_by_category;
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
      // console.log('disable_date_by_slot: ',disable_date_by_slot)
      return disable_date_by_slot;
    },
    formatDate(dateToParse) {
      const dateComponents = dateToParse.split('-');
      const year = parseInt(dateComponents[0]);
      const month = parseInt(dateComponents[1]) - 1;
      const day = parseInt(dateComponents[2]);
      const jsDate = new Date(year, month, day + 1);
      return jsDate;
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
    async get_service_by_category() {
      console.log('service category id is now', this.serviceCategoryId)
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/ServiceByCategory.gql'),
          variables: { id: parseInt(this.$route.params.categoryId)}
        });
        this.service_by_category = response.data.serviceByCategory;
        console.log('list of service by category',this.service_by_category);
      } catch (error) {
        console.error('Error creating like:', error);
      }
    },
    getServiceCategoryURL(item, ite) {
      return `/service_categories/${this.$route.params.categoryId}/services/${item.id}/time_slots/${ite.id}`;
    },
    logCurrentTime() {
      const currentTime = new Date().toLocaleTimeString();
      console.log(`Current time is: ${currentTime}`);
    },
    timeslot_info_event() {
      document.addEventListener('DOMContentLoaded', function() {
      const offcanvas = document.querySelector('.offcanvas_timeslot_info');
      const toggleButton = document.getElementById('toggleButton');

      toggleButton.addEventListener('click', function() {
        offcanvas.classList.toggle('active');
      });
});
    }
  },
  mounted() {
    this.logCurrentTime();
    this.get_service_by_category();
    this.timeslot_info_event();
  } 
}
</script>

<style>
.date_link {
  text-decoration: none;
}

.date_num {
  /* background-color: red; */
  padding: 5px;
}

h5 {
  font-family: Verdana, Geneva, Tahoma, sans-serif;
  font-weight: bolder;
  position: relative;
  /* margin-bottom: 230px; */
  /* margin-top: 220px; */
  z-index: 2;
  /* background-color: rgba(255, 255, 255, 0.5);  */
}

.service_list_customer {
  /* border: 1px solid gray; */
}

.service_list_customer_timeslot {
  position: sticky;
  top: 0; /* Stick to the top of the parent container */ /* Occupy the full viewport height */
  height: 100vh;
}



.test_customer_service {
  display: inline-block;
  white-space: nowrap !important;
  margin-right: 40px;
}

/* Add your CSS styles for .service_list_customer_services here */
.service_list_customer_services {
  padding-bottom: 17px; /* Adjust for scrollbar height */
  max-width: 100%; /* Ensure it takes up the available width */
  height: 100%; /* Optionally, set a fixed height or use flexbox for layout */
}

.service_link {
  text-decoration: none;
  color:rgb(14, 12, 12);
}

.service_box, .service_item {
  margin: 20px 0 0 auto;
  width: 100%;
}

.service_item p {
  font-weight: bold;
  white-space: wrap;
}

.service_details {
  z-index: 2;
}

.service_image {
  opacity: .65;
  z-index: 1;
  border-radius: 5px 5px 0 0;
  max-width: 100%; /* Ensure the image scales down proportionally */
  height: 50%;    /* Maintain the aspect ratio */
  width: 100%;    /* Set a maximum width if needed */
  max-height: 300px;
}

.service_image_whole {
  height: 200px;
  top: 0;
  opacity: .65;
  z-index: 1;
  border-radius: 5px 5px 0 0;
  max-width: 100%; /* Ensure the image scales down proportionally */    /* Maintain the aspect ratio */
  width: 100%;    /* Set a maximum width if needed */
}

.scrollable-list {
  max-height: 100%; /* Allow the list to take the full height of the container */
  overflow-y: auto;
  border: 1px solid #ccc; /* Optional: Add a border for styling */
  padding: 10px; /* Optional: Add padding for spacing */
}

.scrollable-container {
  /* Hide any overflow outside of the container */
  max-height: 100%;
  overflow: hidden;
}

.offcanvas_timeslot_info {
  max-height: 100%; /* Allow the container to take the full height of the parent */
  margin-top: 20px;
  /* width: 250px; */
  width: 100%;
  background-color: #fff;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
  transition: left 0.3s;
  z-index: 1;
  overflow-y: auto;
}

.offcanvas_timeslot_info.active {
  left: 0; /* Slide in from left */
}

/* Style for the radio label */
.radio-label {
  position: relative;
  padding-left: 30px; /* Adjust the padding to your preference */
  padding-bottom: 10px; /* Add margin between options */
  cursor: pointer;
}

/* Style for the radio input (hide the default radio button) */
.radio-input {
  opacity: 0;
  position: absolute;
  left: 0;
  top: 0;
}

/* Style for the border when the radio input is checked */
.radio-label::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 0;
  transform: translateY(-50%);
  width: 20px; /* Adjust the border width */
  height: 20px; /* Adjust the border height */
  border: 2px solid transparent; /* Define the border color and thickness */
  border-radius: 50%; /* Create a circle border */
  background-color: transparent; /* Remove background color */
}

/* Style for the border when the radio input is checked */
.radio-input:checked + .radio-label::before {
  border-color: #007bff; /* Define the border color when checked */
}

/* Increase font size by 5px on hover */
.radio-label:hover {
  font-size: calc(1em + 5px); /* Increase font size by 5px */
}

.tooltip_custom {
  position: relative;
}

.tooltiptext_custom {
  visibility: hidden;
  width: 120px;
  background-color: black;
  color: #fff;
  text-align: center;
  border-radius: 6px;
  padding: 5px 0;

  /* Position the tooltip */
  position: absolute;
  z-index: 1;
}

.tooltip_custom:hover .tooltiptext_custom {
  visibility: visible;
}
</style>
