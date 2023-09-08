<template>
  <div class="container">
    <h1>Cart Page</h1>
    <div class="form-container">
      <form @submit.prevent="submitForm">
        <p>Your official Checkout form</p>
        <div class="mb-3">
          <input type="text" class="form-control" v-model="cart.first_name" placeholder="First Name" required>
        </div>
        <div class="mb-3">
          <input type="text" class="form-control" v-model="cart.last_name" placeholder="Last Name" required>
        </div>
        <div class="mb-3">
          <input type="text" class="form-control" v-model="cart.contact_number" placeholder="Contact Number" required>
        </div>
        <div class="mb-3">
          <input type="text" class="form-control" v-model="cart.email" placeholder="Email" required>
        </div>
        <div class="mb-3">
          <select class="form-select" v-model="cart.payment_option">
            <option value="1">Over the Counter</option>
            <option value="2">Bank Deposit</option>
          </select>
        </div>
        <button type="submit" class="btn btn-primary btn-block">Submit</button>
      </form>
    </div>

    <!-- Table container -->
    <div class="table-container" v-if="cart_content.length > 0">
      <table class="table">
        <thead>
          <tr>
            <th>Service Name</th>
            <th>Date</th>
            <th>Time</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in cart_content" :key="index">
            <td>{{ item.service.name }}</td>
            <td>{{ item.date }}</td>
            <td>{{ item.time }}</td>
            <td>{{ item.status }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      cart: {
        first_name: '',
        last_name: '',
        contact_number: '',
        email: '',
        payment_option: ''
      },
      cart_content: []
    }
  },
  methods: {
    async submitForm() {
      console.log(this.cart)
      try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/CartHistoryCreate.gql'),
          variables: {
            paymentOptionId: parseInt(this.cart.payment_option),
            firstName: this.cart.first_name,
            lastName: this.cart.last_name,
            contactNumber: this.cart.contact_number,
            email: this.cart.email
          },
        });
        console.log(response)

        if (response) { 
          this.reloadPage()
          this.$router.push('/checkout') 
        }
      } catch (error) {
        console.error('Error in create_cart_item:', error);
      }
    },
    async cart_items() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/CartItemCategoryCustomer.gql'),
        });
        this.cart_content = response.data.pending;
      } catch (error) {
        console.error('Error in create_cart_item:', error);
      }
    },
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
/* Style the form container */
.form-container {
    max-width: 400px; /* Adjust the maximum width as needed */
    margin: 0 auto;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  }

  /* Center the text within the form */
  .form-container p {
    text-align: center;
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
</style>
