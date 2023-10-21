<template>
  <div class="container">
    <h1>Thank you for your reservation</h1>
    <div class="letter">
      <p>Dear {{ this.checkout.firstName }} {{ this.checkout.lastName }},</p>
      <p>We wanted to make a moment to express our heartfelt thanks for choosing ServiceBundle for your upcoming reservation.</p>
      <p>We truly appreciate your trust in us and look forward to provide you with an exceptional experience.</p>
      <table class="table table-bordered checkout-table">
        <thead>
          <tr>
            <th colspan="6">Reservation Details</th>
          </tr>
          <tr>
            <th>Reservation ID</th>
            <th>Service Category</th>
            <th>Service Name</th>
            <th>Date</th>
            <th>Time</th>
            <th>Price</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in cart_item" :key="index">
            <td class="rsvn_id">{{ convertToNewID(item.id) }}</td>
            <td>{{ item.service.serviceCategoryId.name }}</td>
            <td>{{ item.service.name }}</td>
            <td>{{ formatDate(item.date) }}</td>
            <td>{{ convertTimeToAMPM(item.time) }}</td>
            <td class="checkout-price">{{ formatToPHP(item.service.price) }}</td>
          </tr>
          <tr class="total">
            <td class="total-label" colspan="5">Total:</td>
            <td class="total-price">{{ formatToPHP(total_price) }}</td>
          </tr>
        </tbody>
      </table>
      <div class="transaction-info">
        <h2>Transaction Information</h2>
        <p>Transaction ID: {{ convertToNewTransID(checkout.id) }}</p>
        <!-- Or if you want to display Cart ID -->
        <!-- <p>Cart ID: {{ cartId }}</p> -->
        <!-- Add more details or customization as needed -->
      </div>
      <!-- Payment Information -->
      <div class="payment-info">
        <h2>Payment Information</h2>
        <!-- Payment Method Option: Over the Counter -->
        <div v-if="paymentMethod === '1'">
          <p>Payment Method: Over the Counter</p>
          <p>Instructions: You can make your payment in person at our service center.</p>
          <!-- Add any specific instructions or details for this payment method -->
        </div>
        <!-- Payment Method Option: Bank Deposit -->
        <div v-else-if="paymentMethod === '2'">
          <p>Payment Method: Bank Deposit</p>
          <p>Bank Name: XYZ Bank</p>
          <p>Account Name: ServiceBundle Inc.</p>
          <p>Account Number: 1234567890</p>
          <p>Instructions: Please make the deposit to the above account number and keep the deposit receipt for your reference.</p>
          <!-- Add any specific bank deposit instructions or details here -->
        </div>
        <!-- Total Amount -->
        <p>Total Amount Charged: {{ formatToPHP(total_price) }}</p>
        <!-- Additional payment details -->
      </div>
      <hr>
      <p>Please review the reservation details above to ensure everything is accurate. If you have any questions or need to make changes, please don't hesitate to contact our customer support team at <a href="mailto:customersupport@servicebundle.com">customersupport@servicebundle.com</a>.</p>
      <p class="important_info">Important Information:</p>
      <ul>
        <li>Cancellation Policy: <a target="_blank" href="#">https://www.servicebundle.com/cancellation_policy</a></li>
        <li>Special Requests: <a target="_blank" href="#">https://www.servicebundle.com/guess_request</a></li>
      </ul>
      <p>If you have any special requests or specific requirements for your reservation, please let us know in advance, and we will do our best to accommodate them.</p>
      <p>Once again, thank you for choosing ServiceBundle. We're thrilled to serve you and are committed to making your experience exceptional.</p>
      <p>Warm regards,</p>
      <ul class="signature">
        <li>John Doe</li>
        <li>CEO</li>
        <li>ServiceBundle</li>
        <li><a href="mailto:johndoe@servicebundle.com">johndoe@servicebundle.com</a></li>
      </ul>
    </div>
  </div>
</template>

<script>

export default {
  name: 'CheckoutPage',
  components: {

  },
  data() {
    return {
      checkout: [],
      cart_item: [],
      total_price: 0,
    }
  }, 
  methods: {
    convertToNewTransID(id) {
      const prefix = '938'; // The common prefix for the new IDs
      const newID = prefix + id.toString().padStart(3, '0');
      return newID;
    },
    convertToNewID(id) {
      const prefix = '12321000'; // The common prefix for the new IDs
      const newID = prefix + id.toString().padStart(5, '0');
      return newID;
    },
    formatDate(inputDate) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      return new Date(inputDate).toLocaleDateString(undefined, options);
    },
    convertTimeToAMPM(timeString) {
      const dateTime = new Date(timeString);
      const hours = dateTime.getUTCHours();
      const minutes = dateTime.getUTCMinutes();
      const ampm = hours >= 12 ? 'PM' : 'AM';
      const formattedHours = hours % 12 || 12; // Convert 0 to 12 for 12-hour format

      const formattedTime = `${formattedHours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')} ${ampm}`;

      return formattedTime;
    },
    formatToPHP(number) {
      // Convert the number to a string with two decimal places
      const formattedNumber = Number(number).toFixed(2);

      // Add "PHP " to the formatted number and use commas as a thousands separator
      const result = `PHP ${formattedNumber.replace(/\B(?=(\d{3})+(?!\d))/g, ', ')}`;

      return result;
    },
    async get_cart_history() {
      try {
        const response = await this.$apollo.query({ 
          query: require('@/graphql/CartHistory.gql'), 
          variables: { id: this.$route.params.cart_history_id }
        });
        if (response.data == null) {
          console.log('null')
        } else {
          this.checkout = response.data.cartHistory
          this.cart_item = response.data.cartHistory.cartItem
          this.paymentMethod = response.data.cartHistory.paymentOption.id
          for (let i = 0; i < this.cart_item.length; i++) {
          if (this.cart_item[i].service.price > 0) { // Check if the subarray is not empty
            this.total_price += this.cart_item[i].service.price;
          }
        }
          if (this.checkout.status == false) {
            this.$route.push('/');
          } else {
            console.log('cart History Info: ', this.checkout);
          }
        }
        // if (this.newServiceData.id) this.merge_new_service_to_services(this.services)
        // if (this.updateServiceData.service_details) this.update_service_list(this.services)
        // if (this.new_time_slot.time_slot) {
        //   this.services[this.new_time_slot.index_to_edit].timeSlot = this.new_time_slot.time_slot;
        //   console.log('ServiceList/get_services:124', this.services[this.new_time_slot.index_to_edit].timeSlot);
        // } 
        // console.log('ServiceList/get_services: new_time_slot.index_to_edit: ', this.new_time_slot.index_to_edit, this.new_time_slot.time_slot);
      } catch (error) {
        console.log('Error from get_cart_history: ', error);
        this.$router.push('/')
      }
    },
  },
  mounted() {
    this.get_cart_history()
  }
}
</script>

<style>
.letter {
  text-align: left;
}

.total-label {
  text-align: right;
}

.total-price {
  text-align: right;
}

.total, .important_info {
  font-weight: bold;
}

.checkout-price {
  text-align: right;
}

.checkout-table th, .rsvn_id {
  text-align: center;
}

.signature {
  list-style-type: none;
  padding-left: 0;
}
</style>