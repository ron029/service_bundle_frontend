<template>
  <div>
      <!-- <% provide(:title, custom_title('Sign Up'))%> -->
      <div class="container h-custom">
          <div class="row d-flex justify-content-center align-items-center h-100">
              <div class="col-md-8 col-lg-6 col-xl-4 offset-xl-1">
                  <div class="d-flex flex-row align-items-center justify-content-center justify-content-lg-start">
                      <p class="login_text lead fw-normal mb-0 me-3"></p>
                  </div>
                  <div class="register-stepper">
                      <div class="step" :class="{'step-active' : step === 1, 'step-done': step > 1}"><span class="step-number">1</span></div>
                      <div class="step" :class="{'step-active' : step === 2, 'step-done': step > 2}"><span class="step-number">2</span></div>
                      <div class="step" :class="{'step-active' : step === 3, 'step-done': step > 3}"><span class="step-number">3</span></div>
                      <div class="step" :class="{'step-active' : step === 3, 'step-done': step > 3}"><span class="step-number">4</span></div>
                      <div class="step" :class="{'step-active' : step === 3, 'step-done': step > 3}"><span class="step-number">5</span></div>
                  </div>
                  <form @submit.prevent="submitForm">
                      <transition name="slide-fade">
                          <section v-show="step === 1">
                                <p>Who owns the business.</p>
                                <!-- First name -->
                                <div class="row input-field-signup mt-3">
                                    <div class="col-sm-6 col-form-label">
                                        <div :class="{ error: v$.first_name.$errors.length }">
                                            <label class="form-label" for="first_name">First Name</label>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 err-card">
                                        <input v-model="first_name" class="form-control form-control-l" :class="{ error: v$.first_name.$errors.length }" id="first_name">
                                        <div class="input-errors" v-for="error of v$.first_name.$errors" :key="error.$uid" placeholder="Enter your first name" autofocus>
                                            <div class="error-msg">{{ error.$message }}</div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Last name -->
                                <div class="row input-field-signup mt-3">
                                    <div class="col-sm-6 col-form-label">
                                        <div :class="{ error: v$.last_name.$errors.length }">
                                            <label class="form-label" for="last_name">Last Name</label>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 err-card">
                                        <input v-model="last_name" class="form-control form-control-l" :class="{ error: v$.last_name.$errors.length }" id="last_name">
                                        <div class="input-errors" v-for="error of v$.last_name.$errors" :key="error.$uid" placeholder="Enter your last name" autofocus>
                                            <div class="error-msg">{{ error.$message }}</div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Mobile Number -->
                                <div class="row input-field-signup mt-3">
                                    <div class="col-sm-6 col-form-label">
                                        <div :class="{ error: v$.mobile_number.$errors.length }">
                                            <label class="form-label" for="mobile_number">Mobile Number</label>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 err-card">
                                        <input v-model="mobile_number" class="form-control form-control-l" :class="{ error: v$.mobile_number.$errors.length }" id="mobile_number">
                                        <div class="input-errors" v-for="error of v$.mobile_number.$errors" :key="error.$uid" placeholder="Enter your mobile number">
                                            <div class="error-msg">{{ error.$message }}</div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Email -->
                                <div class="row input-field-signup mt-3">
                                    <div class="col-sm-6 col-form-label">
                                        <div :class="{ error: v$.email.$errors.length }">
                                            <label class="form-label" for="email">Email</label>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 err-card">
                                        <input v-model="email" class="form-control form-control-l" :class="{ error: v$.email.$errors.length }" id="email">
                                        <div class="input-errors" v-for="error of v$.email.$errors" :key="error.$uid" placeholder="Enter your Email">
                                            <div class="error-msg">{{ error.$message }}</div>
                                        </div>
                                    </div>
                                </div>
                              <a class="link_text" href="#" @click.prevent="next1()"><span class="arrow-prev"></span>Next </a>
                          </section>
                      </transition>
                      <transition name="slide-fade">
                          <section v-show="step === 2">
                                <p>Describe your business</p>
                                <!-- Service Name -->
                                <div class="row input-field-signup mt-3">
                                    <div class="col-sm-6 col-form-label">
                                        <div :class="{ error: v$.service_name.$errors.length }">
                                            <label class="form-label" for="service_name">service_name</label>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 err-card">
                                        <input v-model="service_name" class="form-control form-control-l" :class="{ error: v$.service_name.$errors.length }" id="service_name" type="service_name">
                                        <div class="input-errors" v-for="error of v$.service_name.$errors" :key="error.$uid">
                                            <div class="error-msg">{{ error.$message }}</div>
                                        </div>
                                    </div>
                                </div>
                                <!--Service Category -->
                                <div class="row input-field-signup mt-3">
                                    <div class="col-sm-6 col-form-label">
                                        <div :class="{ error: v$.service_category.$errors.length }">
                                            <label class="form-label" for="service_category">Service Category</label>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 err-card">
                                        <select v-model="service_category" class="form-control form-control-l" :class="{ error: v$.service_category.$errors.length }" id="service_category">
                                            <option v-for="category in service_categories" :key="category.id" :value="category.id">
                                            {{ category.name }}
                                            </option>
                                        </select>
                                        <div class="input-errors" v-for="error of v$.service_category.$errors" :key="error.$uid">
                                            <div class="error-msg">{{ error.$message }}</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row input-field-signup mt-3">
                                    <div class="col-sm-6 col-form-label">
                                        <div :class="{ error: v$.price.$errors.length }">
                                            <label class="form-label" for="price">price</label>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 err-card">
                                        <input v-model="price" class="form-control form-control-l" :class="{ error: v$.price.$errors.length }" id="price" type="price">
                                        <div class="input-errors" v-for="error of v$.service_name.$errors" :key="error.$uid" placeholder="">
                                            <div class="error-msg">{{ error.$message }}</div>
                                        </div>
                                    </div>
                                    <div class="row input-field-signup mt-3">
                                    <div class="col-sm-6 col-form-label">
                                        <div :class="{ error: v$.description.$errors.length }">
                                            <label class="form-label" for="description">description</label>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 err-card">
                                        <textarea v-model="description" class="form-control form-control-l" :class="{ error: v$.description.$errors.length }" id="description" type="description"></textarea>
                                        <div class="input-errors" v-for="error of v$.description.$errors" :key="error.$uid">
                                            <div class="error-msg">{{ error.$message }}</div>
                                        </div>
                                    </div>
                                </div>
                                </div>
                              <a class="link_text" href="#" @click.prevent="prev()"><span class="arrow-prev"></span>Previous </a>
                              <a class="link_text" href="#" @click.prevent="next2()"><span class="arrow-prev"></span>Next </a>
                          </section>
                      </transition>
                      <transition name="slide-fade">
                          <section v-show="step === 3">
                                <p>Create a strong password.</p>
                              <!-- Password -->
                              <div class="row input-field-signup mt-3">
                                  <div class="col-sm-6 col-form-label">
                                      <div :class="{ error: v$.password.$errors.length }">
                                          <label class="form-label" for="password">Password</label>
                                      </div>
                                  </div>
                                  <div class="col-sm-6 err-card">
                                      <input v-model="password" class="form-control form-control-l" :class="{ error: v$.password.$errors.length }" id="password" type="password">
                                      <div class="input-errors" v-for="error of v$.password.$errors" :key="error.$uid" placeholder="Enter your Password">
                                          <div class="error-msg">{{ error.$message }}</div>
                                      </div>
                                  </div>
                              </div>
                              <!-- Password Confirmation -->
                              <div class="row input-field-signup mt-3">
                                  <div class="col-sm-6 col-form-label">
                                      <div :class="{ error: v$.password_confirmation.$errors.length }">
                                          <label class="form-label" for="password_confirmation">Password Confirmation</label>
                                      </div>
                                  </div>
                                  <div class="col-sm-6 err-card">
                                      <input v-model="password_confirmation" class="form-control form-control-l" :class="{ error: v$.password_confirmation.$errors.length }" id="password_confirmation" type="password">
                                      <div class="input-errors" v-for="error of v$.password_confirmation.$errors" :key="error.$uid" placeholder="Enter your Password Confirmation">
                                          <div class="error-msg">{{ error.$message }}</div>
                                      </div>
                                  </div>
                              </div>
                              <a class="link_text" href="#" @click.prevent="prev()"><span class="arrow-prev"></span>Previous </a>
                              <div class="d-flex justify-content-between align-items-center">
                                  
                              </div>
                              <div class="text-right mt-4">
                                  <button type="submit" class="btn btn-primary btn-lg input-field-signup" style="padding-left: 2.5rem; padding-right: 2.5rem;">Sign up</button>
                              </div>
                          </section>
                      </transition>
                  </form>
              </div>
              <div class="col-md-9 col-lg-6 col-xl-5">
                  <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-login-form/draw2.webp" class="img-fluid" alt="Login to MovieMagic">
              </div>
          </div>
      </div>
  </div>
</template>

<script>
import { useVuelidate } from '@vuelidate/core';
import SignInUser from '@/graphql/Login.gql';
import { required, email, helpers, numeric, minLength, maxLength, sameAs } from '@vuelidate/validators';
import { onLogin, createProvider } from '@/vue-apollo.js';
import { mapState, mapMutations } from 'vuex';
import store from '@/store';
const fields = {
  page1: ['first_name', 'last_name', 'mobile_number', 'email'],
  page2: ['service_name','price','description'],
  page5: ['password', 'password_confirmation']
};
export default {
  name: 'LoginForm',
  setup () { return { v$: useVuelidate() } },
  data () {
      return {
          steps: {},
          step: 1,
          hasSeenCongrats: false,
          first_name: null,
          last_name: null,
          mobile_number: null,
          email: null,
          password: null,
          password_confirmation: null,
          price: null,
          service_category: null,
          service_name: null,
          description: null,
          service_categories: []
      }
  },
  validations () {
      const alphabeticWithSpaces = value => /^[a-zA-Z\s]*$/.test(value);
      return {
          first_name: {
              required: helpers.withMessage('First Name is required.', required),
              alphabeticWithSpaces: helpers.withMessage('First Name can only contain letters and spaces.', alphabeticWithSpaces),
          }, 
          last_name: {
              required: helpers.withMessage('Last Name is required.', required),
              alphabeticWithSpaces: helpers.withMessage('Last Name can only contain letters and spaces.', alphabeticWithSpaces),
          },
          price: {numeric, required},
          description: {required},
          service_category: { },
          service_name: { required },
          mobile_number: { required: helpers.withMessage('Mobile Number is required.', required), numeric },
          email: { required, email },
          password: { required: helpers.withMessage('Password is required.', required), minLength: minLength(8), maxLength: maxLength(20) },
          password_confirmation: { sameAs: sameAs(this.password) }
      }
  },
  methods: {
    async show_categories() {
      try {
        const response = await this.$apollo.query({
          query: require('@/graphql/Categories.gql'),
        });
        console.log('the service category is here', response)
         this.service_categories = response.data.categories;
         console.log(response)
      } catch (error) {
          console.error('Error logging out:', error);
      }
    },
      
      prev() {
          this.step--;
      },
      field_to_validate(fields) {
          const last_step = 5
          let error = 0;
          for (const field of fields) {
              this.v$[field].$touch();
              if (this.v$[field].$error) error++;
          }
          if (!error) {
              if (this.step != last_step) this.step++;
              return true;
          }
      },
      next1() {
          this.field_to_validate(fields.page1);
      },
      next2() {
          this.field_to_validate(fields.page2);
          
      },
      next3() {
          this.field_to_validate(fields.page3);
      },
      next4() {
          this.field_to_validate(fields.page4);
      },
      async submitForm() {
        if (!this.v$.$touch()) {
                try {
                    const response = await this.$apollo.mutate({
                        mutation: require('@/graphql/Signup.gql'),
                        variables: {
                            "signupInput": {
                                "role": 1,
                                "firstName": this.first_name,
                                "lastName": this.last_name,
                                "mobileNumber": this.mobile_number,
                                "authProvider": {
                                    "credentials": {
                                        "email": this.email,
                                        "password": this.password,
                                        "passwordConfirmation": this.password_confirmation
                                    }
                                }
                            }
                        }
                    });
                    console.log(response)
                    if (response.data.createUser.errors > 0) {
                        console.log(response.data.createUser.errors);
                    } else {
                        const login = await this.forceLogin();
                        await this.create_service();
                        if (login && this.$route.path !== '/') {
                            this.$router.push('/merchant');
                        } else {
                            alert('Something went wrong. Please try again later');
                        }
                    }
                } catch (error) {
                    console.error("Client Error:", error);
                }
            }
      },
      async forceLogin() {
          const response = await this.$apollo.mutate({
              mutation: SignInUser,
              variables: {
                  credentials: {
                      email: this.email,
                      password: this.password
                  }
              },
          });
          console.log(response)
          const token = await response.data.login.token
          // assign the Authorization header with the token provided by the backend
          const headers = { Authorization: token };
          const role = await response.data.login.role;
                    console.log('The role get from the service vie response data is ', role)
                    await this.updateUserRole(role)
                    console.log('new role now',this.userRole);
          // tells vue that authentication is true and chance some components
          this.toggleAuthentication();
          // store the token in localStorate 
          // using the default onLogin method provided by vue-apollo.js
          await onLogin(createProvider({}, headers), token);
          return response.data.login === null ? false : true;
      },
      async create_service() {
        try {
        const response = await this.$apollo.mutate({
          mutation: require('@/graphql/ServiceCreate.gql'),
          variables: {
            serviceCategoryId: parseInt(this.service_category),
            name: this.service_name,
            description: this.description,
            price: parseInt(this.price)
          },
        });
        if(response) { console.log(response) }
        this.time_slot_one = null;
        } catch (error) { console.error("Graphql Error:", error); }
      },
      ...mapMutations(['setAuthenticated']),
    toggleAuthentication() {
        this.setAuthenticated(!this.isAuthenticated);
    },
    get_role(){
        const userRole = localStorage.getItem('userRole');
        return userRole;
    },

    updateUserRole(role) {
        // Call the mutation 'setUserRole' with a payload (userRole)
        store.commit('setUserRole', role); // Replace 'admin' with your actual user role data
    },
  },
  computed: {
      ...mapState(['isAuthenticated']),
  },
  mounted(){
    this.show_categories()
  }
}
</script>

<style>
.error, .error:focus, .error input[type="radio"] {
  border-color: red;
  color: red;
}
.input-errors {
  color: red;
}
.err-card {
  position: relative;
}
.error-msg {
  position: absolute;
  font-size: 10px;
  bottom: -8px;
  left: 17px;
}
.register-stepper {
  display: none;
}
</style>