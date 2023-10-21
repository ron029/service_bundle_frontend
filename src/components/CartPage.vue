<template>
  <div class="container">
    <div v-if="step != 1">
      <h1>Checkout</h1>
      <p class="checkout-back">
        <button class="checkout-back-button" href="#" @click.prevent="prev()">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-left-square-fill" viewBox="0 0 16 16">
            <path d="M16 14a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12zm-4.5-6.5H5.707l2.147-2.146a.5.5 0 1 0-.708-.708l-3 3a.5.5 0 0 0 0 .708l3 3a.5.5 0 0 0 .708-.708L5.707 8.5H11.5a.5.5 0 0 0 0-1z"/>
          </svg>  
          Back
        </button>
      </p>
    </div>
    <!-- <div class="register-stepper">
      <div class="step" :class="{'step-active' : step === 1, 'step-done': step > 1}"><span class="step-number">1</span></div>
      <div class="step" :class="{'step-active' : step === 2, 'step-done': step > 2}"><span class="step-number">2</span></div>
      <div class="step" :class="{'step-active' : step === 3, 'step-done': step > 3}"><span class="step-number">3</span></div>
    </div> -->
    <transition name="slide-fade">
      <section v-show="step === 1">
        <!-- Table container -->
        <div class="row">
          <div class="col-md-8">
            <div class="cart-title">
              <h1 class="cart-header">My Cart</h1>
              <a href="/">
                <h2 class="cart-nav-continue">Return to Homepage
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-right-square-fill" viewBox="0 0 16 16">
                    <path d="M0 14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2a2 2 0 0 0-2 2v12zm4.5-6.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5a.5.5 0 0 1 0-1z"/>
                  </svg>
                </h2>
              </a>
            </div>
            <div v-if="cart_content.length > 0">
              <div v-for="(item, index) in cart_content" :key="index" class="row cart-item">
                <div class="col-md-4">
                  <img :src="item.service.image" :alt="item.service.name" style="width: 150px; height: 150px;">
                </div>
                <div class="col-md-8">
                  <ul class="cart-item-info">
                    <li>Service Name: {{ item.service.name }}</li>
                    <li>
                      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-calendar3" viewBox="0 0 16 16">
                        <path d="M14 0H2a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2zM1 3.857C1 3.384 1.448 3 2 3h12c.552 0 1 .384 1 .857v10.286c0 .473-.448.857-1 .857H2c-.552 0-1-.384-1-.857V3.857z"/>
                        <path d="M6.5 7a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm-9 3a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm-9 3a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
                      </svg>&nbsp;&nbsp;{{ formatDate(item.date) }}
                    </li>
                    <li>
                      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-clock" viewBox="0 0 16 16">
                        <path d="M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71V3.5z"/>
                        <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm7-8A7 7 0 1 1 1 8a7 7 0 0 1 14 0z"/>
                      </svg>&nbsp;&nbsp;{{ convertTimeToAMPM(item.time) }}
                    </li>
                    <li class="price">Price: <span>{{ formatToPHP(item.service.price) }}</span></li>
                  </ul>
                </div>
              </div>
            </div>
            <div v-else class="empty-cart">
              <img src="https://i.imgur.com/dCdflKN.png" width="130" height="130" class="img-fluid mb-4 mr-3 cart-empty-img">
              <h3>No Items in your Cart.</h3>
            </div>
          </div>
          <div class="col-md-4">
            <h2 class="summary">Summary</h2>
            <hr>
            <p>Total Price: {{ formatToPHP(total_price) }}</p>
            <hr>
            <button :disabled="cart_content.length === 0" class="checkout-button" href="#" @click.prevent="next1()">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-bag-fill" viewBox="0 1 16 16">
                <path d="M8 1a2.5 2.5 0 0 1 2.5 2.5V4h-5v-.5A2.5 2.5 0 0 1 8 1zm3.5 3v-.5a3.5 3.5 0 1 0-7 0V4H1v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V4h-3.5z"/>
              </svg> 
              Checkout
            </button>
          </div>
        </div>
      </section>
    </transition>
    <transition name="slide-fade">
      <section v-show="step === 2">
        <form class="row" @submit.prevent="submitForm">
          <div class="col-md-6">
            <div class="form-container">
              <p class="header-checkout">Contact Information</p>
              <!-- first name -->
              <div class="mb-3 err-card-cart">
                <div class="row input-field-signup mt-3">
                  <div class="col-sm-4 col-form-label">
                    <div :class="{ error: v$.cart.first_name.$errors.length }">
                      <label class="form-label" for="first_name">First Name</label>
                    </div>
                  </div>
                  <div class="col-sm-8 err-card">
                    <input v-model="cart.first_name" class="form-control form-control-l" :class="{ error: v$.cart.first_name.$errors.length }" id="first_name">
                    <div class="input-errors" v-for="error of v$.cart.first_name.$errors" :key="error.$uid">
                      <div class="error-msg">{{ error.$message }}</div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- last name -->
              <div class="mb-3 err-card-cart">
                <div class="row input-field-signup mt-3">
                  <div class="col-sm-4 col-form-label">
                    <div :class="{ error: v$.cart.last_name.$errors.length }">
                      <label class="form-label" for="last_name">Last Name</label>
                    </div>
                  </div>
                  <div class="col-sm-8 err-card">
                    <input v-model="cart.last_name" class="form-control form-control-l" :class="{ error: v$.cart.last_name.$errors.length }" id="last_name">
                    <div class="input-errors" v-for="error of v$.cart.last_name.$errors" :key="error.$uid">
                      <div class="error-msg">{{ error.$message }}</div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- contact number -->
              <div class="mb-3 err-card-cart">
                <div class="row input-field-signup mt-3">
                  <div class="col-sm-4 col-form-label">
                    <div :class="{ error: v$.cart.contact_number.$errors.length }">
                      <label class="form-label contact_number_cart" for="contact_number">Contact Number</label>
                    </div>
                  </div>
                  <div class="col-sm-8 err-card">
                    <input v-model="cart.contact_number" class="form-control form-control-l" :class="{ error: v$.cart.contact_number.$errors.length }" id="contact_number">
                    <div class="input-errors" v-for="error of v$.cart.contact_number.$errors" :key="error.$uid">
                      <div class="error-msg">{{ error.$message }}</div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- email -->
              <div class="mb-3 err-card-cart">
                <div class="row input-field-signup mt-3">
                  <div class="col-sm-4 col-form-label">
                    <div :class="{ error: v$.cart.email.$errors.length }">
                      <label class="form-label" for="email">Email Address</label>
                    </div>
                  </div>
                  <div class="col-sm-8 err-card">
                    <input v-model="cart.email" class="form-control form-control-l" :class="{ error: v$.cart.email.$errors.length }" id="email">
                    <div class="input-errors" v-for="error of v$.cart.email.$errors" :key="error.$uid">
                      <div class="error-msg">{{ error.$message }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="form-container">
              <p class="header-checkout">Payment Method</p>
              <div class="row payment_option_input">
                <div class="col-sm-4 col-form-label">
                  <div :class="{ error: v$.cart.payment_option.$errors.length }">
                    <label class="form-label" for="payment_option">Payment Option</label>
                  </div>
                </div>
                <div class="col-sm-8 err-card">
                  <select v-model="cart.payment_option" class="form-control form-control-l" :class="{ error: v$.cart.payment_option.$errors.length }" id="payment_option">
                    <option value="" disabled selected>-- Select --</option>
                    <option value="1">Over the Counter</option>
                    <option value="2">Bank Deposit</option>
                  </select>
                  <div class="input-errors" v-for="error of v$.cart.payment_option.$errors" :key="error.$uid">
                    <div class="error-msg">{{ error.$message }}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-container checkout-item">
              <div v-for="(item, index) in cart_content" :key="index" class="row cart-item">
                <div class="col-md-4">
                  <img :src="item.service.image" :alt="item.service.name" style="width: 150px; height: 150px;">
                </div>
                <div class="col-md-8">
                  <ul class="cart-item-info">
                    <li>Service Name: {{ item.service.name }}</li>
                    <li>{{ formatDate(item.date) }} @ {{ convertTimeToAMPM(item.time) }}</li>
                    <li class="price">Price: <span>{{ formatToPHP(item.service.price) }}</span></li>
                  </ul>
                </div>
              </div>
              <div class="total_price">
                <p>Total: {{ formatToPHP(total_price) }}</p>
              </div>
              <div class="form-group">
                <div :class="{ error: v$.terms.$errors.length }">
                  <input type="checkbox" id="termsCheckbox" v-model="terms">
                  <label class="form-label" for="termsCheckbox">&nbsp;I agree to the terms and conditions</label>
                </div>
              </div>
              <button type="submit" class="btn btn-primary btn-lg input-field-signup" style="padding-left: 2.5rem; padding-right: 2.5rem;">Confirm Reservation</button>
            </div>
          </div>
        </form>
      </section>
    </transition>
  </div>
</template>

<script>
import { useVuelidate } from '@vuelidate/core';
import { required, email, helpers, numeric, } from '@vuelidate/validators';
const fields = {
    page1: [],
    page2: ['first_name', 'last_name', 'contact_number', 'email', 'payment_option', 'terms'],
};

export default {
  name: 'CartPage',
  components: {

  },
  setup () { return { v$: useVuelidate() } },
  data() {
    return {
      cart: {
        first_name: '',
        last_name: '',
        contact_number: '',
        email: '',
        payment_option: ''
      },
      total_price: 0,
      terms: false,
      cart_content: [],
      steps: {},
      step: 1,
      hasSeenCongrats: false,
    }
  },
  validations () {
    const alphabeticWithSpaces = value => /^[a-zA-Z\s]*$/.test(value);
    return {
      cart: {
        first_name: {
          required: helpers.withMessage('First Name is required.', required),
          alphabeticWithSpaces: helpers.withMessage('First Name can only contain letters and spaces.', alphabeticWithSpaces),
        },
        last_name: {
          required: helpers.withMessage('Last Name is required.', required),
          alphabeticWithSpaces: helpers.withMessage('Last Name can only contain letters and spaces.', alphabeticWithSpaces),
        },
        contact_number: { required: helpers.withMessage('Contact Number is required.', required), numeric },
        email: { required: helpers.withMessage('Email Address is required.', required), email },
        payment_option: {required: helpers.withMessage('Payment Option is required.', required)},
      },
      terms: { isChecked: value => value === true, },
    }
  },
  methods: {
    formatToPHP(number) {
      // Convert the number to a string with two decimal places
      const formattedNumber = Number(number).toFixed(2);

      // Add "PHP " to the formatted number and use commas as a thousands separator
      const result = `PHP ${formattedNumber.replace(/\B(?=(\d{3})+(?!\d))/g, ', ')}`;

      return result;
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
    async submitForm() {
      this.v$.$touch();
      if (!this.v$.$errors.length > 0) {
        try {
          const response = await this.$apollo.mutate({
            mutation: require('@/graphql/CartHistoryCreate.gql'),
            variables: {
              paymentOptionId: this.cart.payment_option,
              firstName: this.cart.first_name,
              lastName: this.cart.last_name,
              contactNumber: this.cart.contact_number,
              email: this.cart.email
            },
          });
          console.log(response.data.createCartHistory)
          if (response) {
            this.cart_content = [];
            this.$router.push(`/checkout/${response.data.createCartHistory.cartHistory.id}`);
          }
        } catch (error) {
          console.error('Error in create_cart_item:', error);
        }
      } else {
        console.log(this.v$.$errors)
      }
    },
    async cart_items() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/CartItemCategoryCustomer.gql'),
        });
        this.cart_content = response.data.pending;
        for (let i = 0; i < this.cart_content.length; i++) {
          if (this.cart_content[i].service.price > 0) { // Check if the subarray is not empty
            this.total_price += this.cart_content[i].service.price;
          }
        }
      } catch (error) {
        console.error('Error in create_cart_item:', error);
      }
    },
    prev() { this.step--; },
    field_to_validate(fields) {
      const last_step = 2
      let error = 0;
      for (const field of fields) {
          this.v$.cart[field].$touch();
          if (this.v$.cart[field].$error) error++;
      }
      if (!error) {
          if (this.step != last_step) this.step++;
          return true;
      }
    },
    next1() {
      this.field_to_validate(fields.page1);
      if (this.cart_content.length == 0) { this.$router.push('/'); }
    },
    next2() { this.field_to_validate(fields.page2); },
    reloadPage() {
      // Reload the current page
      window.location.reload();
    },
  },
  mounted(){
    this.cart_items()
  }
}
</script>

<style>
.contact_number_cart {
  white-space: nowrap;
}

.checkout-table {
  width: 980px;
}

.cart-title {
  position: relative;
  margin-bottom: 50px;
}

.cart-header {
  position: absolute;
  display: inline-block;
  left: 0;
}

.cart-nav-continue {
  font-size: 20px;
  color: darkgray;
  margin-top: 12px;
  position: absolute;
  display: inline-block;
  right: 0;
}

/* In your CSS file or style block */
.checkout-button, .checkout-back-button {
  background-color: #007bff; /* Blue background color */
  color: #fff; /* White text color */
  border: none; /* Remove the border */
  padding: 10px 20px; /* Adjust padding as needed */
  font-size: 16px; /* Adjust font size as needed */
  cursor: pointer; /* Show pointer cursor on hover */
  /* Add more styles as needed */
}

.checkout-back {
  text-align: left;
}

.checkout-button:hover {
  background-color: #0056b3; /* Darker blue on hover */
  /* Add more hover styles if desired */
}

.summary {
  margin-top: 50px;
}

.cart-item {
  margin: 5px 0;
  border: 1px solid rgb(202, 199, 199);
  padding: 20px 10px;
}

.empty-cart {
  min-height: 400px;
}

.cart-empty-img {
  margin-top: 100px;
}

.cart-item-info {
  text-align: left;
  line-height: 35px;
  list-style-type: none;
}

.header-checkout {
  font-weight: bold;
}
/* Style the form container */
.form-container {
  max-width: 100%; /* Adjust the maximum width as needed */
  margin: 0 auto 20px auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.checkout-item {
  /* box-shadow: 0 0 10px rgba(0, 0, 0); */
  border: 2px solid #007BFF;
}

.price {
  position: relative;
  font-weight: bold;
}

.price span {
  position: absolute;
  right: 0;
}

/* Center the text within the form */
.form-container p {
  text-align: center;
}

.total_price {
  font-size: 30px;
  padding: 15px 20px 0 0;
  text-align: right;
  font-weight: bold;
  margin: 30px 0;
  border-top: 1px solid gray;
  border-bottom: 1px solid gray;

}

.total_price p {
  display: inline-block;
}

/* Style form inputs and select */
.form-control {
  margin-bottom: 10px;
}

/* Style the submit button */
.btn-primary {
  background-color: #007bff; /* Primary button color */
  color: #fff;
  border: none;
}

/* Style the submit button on hover */
.btn-primary:hover {
  background-color: #0056b3; /* Darker shade of primary color */
}

/* Style the table */
.table-container {
  margin-top: 20px; /* Add spacing between form and table */
}

/* Style table headers */
.table th {
  background-color: #007bff;
  color: #fff;
}

/* Style table rows */
.table tbody tr:nth-child(even) {
  background-color: #f2f2f2;
}

.error, .error:focus, .error input[type="radio"] {
  border-color: red;
  color: red;
}

.input-errors {
  color: red;
}

.err-card-cart {
  position: relative;
}

.err-card .form-check {
  text-align: left;
}

.error-msg-cart {
  position: absolute;
  font-size: 10px;
  bottom: -12px;
  left: 5px;
}

.register-stepper {
  /* display: none; */
}
</style>
