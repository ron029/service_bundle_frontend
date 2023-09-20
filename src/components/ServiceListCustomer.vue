<template>
  <div class="container">
    <h1>Services</h1>
    <div class="row">
      <div v-for="(item, index) in service_by_category" :key="index" class="col-md-4 mb-3">
        <div class="card">
          <div class="card-body service_item">
            <a class="service_link" :href="generate_service_link(item.id)">
              <h5>{{ item.name }}</h5>
              <img class="service_image" :src="item.image" width="250px" height="250px">
              <p class="service_details">{{ item.description }}</p>
              <p class="service_details">{{ formatToPHP(item.price) }}</p>
            </a>
            <table class="table service_details">
              <thead>
                <tr>
                  <th>Schedule</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <div class="time">
                    <datepicker
                    :disabled-dates="getDisabledDates(item.timeSlot)"
                    :day-cell-content="params => format_date(params, item)"
                    :inline="true">
                    </datepicker>
                  </div>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Datepicker from 'vuejs-datepicker';
export default {
  name: 'ServiceListCustomer',
  data() {
    return {
      service_by_category: [],
    }
  },
  components: { Datepicker, },
  methods: { 
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
    findDateRangeIndex(dateRanges, targetDate) {
      for (let i = 0; i < dateRanges.length; i++) {
        const { startDate, endDate } = dateRanges[i];
        const date = new Date(targetDate);

        if (date >= new Date(startDate) && date <= new Date(endDate)) {
          return i; // Return the index if the date is within the range
        }
      }
      return -1; // Return -1 if the date is not found in any range
    },
    format_date(params, item) {
      if (params.isDisabled == false) {
        console.log('item var: ', item.timeSlot, params)
        console.log('the time is: ', this.timestampTodate(params.timestamp));
        let range = item.timeSlot[this.findDateRangeIndex(item.timeSlot, this.timestampTodate(params.timestamp))];
        console.log('timeslot info is: ', range);
        return `<span class="date_num" onclick="window.location.href='/service_categories/${this.$route.params.categoryId}/services/${item.id}/time_slots/${range.id}?date=${this.timestampTodate(params.timestamp)}'">${params.date}</span>`;
      } else {
        return params.date
      }
    },
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
          const formattedDate = `${date.toISOString().split('T')[0]}`;
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
    async get_service_by_category() {
      console.log('service category id is now', this.serviceCategoryId)
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/ServiceByCategory.gql'),
          variables: { id: parseInt(this.$route.params.categoryId)}
        });
        this.service_by_category = response.data.serviceByCategory;
        console.log(this.service_by_category);
      } catch (error) { 
          console.error('Error creating like:', error);
      }
    },
    getServiceCategoryURL(item, ite) {
      return `/service_categories/${this.$route.params.categoryId}/services/${item.id}/time_slots/${ite.id}`;
    }    
  },
  mounted() {
    this.get_service_by_category()
  } 
}
</script>

<style>
.date_link {
  text-decoration: none;
}

.date_num {
  /* background-color: red; */
  padding: 6px;
}

h5 {
  font-family: Verdana, Geneva, Tahoma, sans-serif;
  font-weight: bolder;
  position: relative;
  margin-bottom: 230px;
  z-index: 2;
  background-color: rgba(255, 255, 255, 0.7);
}

.service_link{
  text-decoration: none;
  color: black;
}

.service_item {
  position: relative;
  z-index: 0;
}

.service_item p {
  font-weight: bold;
}

.service_details {
  position: relative;
  z-index: 2;
}

.service_image {
  top: 10px;
  position: absolute;
  left: 50%; /* Move the element halfway across the viewport horizontally */
  transform: translateX(-50%); /* Center the element */
  z-index: 1;
}
</style>
