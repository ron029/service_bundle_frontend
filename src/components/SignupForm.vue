<template>
    <div>
        <div class="container h-custom">
            <div class="row d-flex justify-content-center align-items-center h-100">
                <div class="col-md-8 col-lg-6 col-xl-4 offset-xl-1">
                    <div class="d-flex flex-row align-items-center justify-content-center justify-content-lg-start">
                        <p class="login_text lead fw-normal mb-0 me-3"></p>
                    </div>
                    <form @submit.prevent="submitForm">
                        <!-- First name -->
                        <div class="row input-field-signup mt-3">
                            <div class="col-sm-6 col-form-label">
                                <div :class="{ error: v$.first_name.$errors.length }">
                                    <label class="form-label" for="first_name">First Name</label>
                                </div>
                            </div>
                            <div class="col-sm-6 err-card">
                                <input v-model="first_name" class="form-control form-control-l" :class="{ error: v$.first_name.$errors.length }" id="first_name" autofocus>
                                <div class="input-errors" v-for="error of v$.first_name.$errors" :key="error.$uid">
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
                                <div class="input-errors" v-for="error of v$.last_name.$errors" :key="error.$uid">
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
                                <div class="input-errors" v-for="error of v$.email.$errors" :key="error.$uid">
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
                                <div class="input-errors" v-for="error of v$.mobile_number.$errors" :key="error.$uid">
                                    <div class="error-msg">{{ error.$message }}</div>
                                </div>
                            </div>
                        </div>
                        <!-- Password -->
                        <div class="row input-field-signup mt-3">
                            <div class="col-sm-6 col-form-label">
                                <div :class="{ error: v$.password.$errors.length }">
                                    <label class="form-label" for="password">Password</label>
                                </div>
                            </div>
                            <div class="col-sm-6 err-card">
                                <input v-model="password" class="form-control form-control-l" :class="{ error: v$.password.$errors.length }" id="password" type="password">
                                <div class="input-errors" v-for="error of v$.password.$errors" :key="error.$uid">
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
                                <div class="input-errors" v-for="error of v$.password_confirmation.$errors" :key="error.$uid">
                                    <div class="error-msg">{{ error.$message }}</div>
                                </div>
                            </div>
                        </div>
                        <div class="text-right mt-4">
                            <button type="submit" class="btn btn-primary btn-lg input-field-signup" style="padding-left: 2.5rem; padding-right: 2.5rem;">Sign up</button>
                            <!-- <p class=" input-field-signup">Already have an account? -->
                                <!-- <%= link_to 'Login', login_path, class: 'link-primary'%> -->
                                <!-- <a href="#">Login</a>
                            </p> -->
                        </div>
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

export default {
    name: 'LoginForm',
    setup () { return { v$: useVuelidate() } },
    data () {
        return {
            first_name: null,
            last_name: null,
            mobile_number: null,
            email: null,
            password: null,
            password_confirmation: null,
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
            mobile_number: { required: helpers.withMessage('Mobile Number is required.', required), numeric },
            email: {
                required,
                email
            },
            password: { required: helpers.withMessage('Password is required.', required), minLength: minLength(8), maxLength: maxLength(20) },
            password_confirmation: { sameAs: sameAs(this.password) }
        }
    },
    methods: {
        ...mapMutations(['setAuthenticated']),
        toggleAuthentication() {
            this.setAuthenticated(!this.isAuthenticated);
        },
        async submitForm() {
            if (!this.v$.$touch()) {
                try {
                    const response = await this.$apollo.mutate({
                        mutation: require('@/graphql/Signup.gql'),
                        variables: {
                            "signupInput": {
                                "role":0,
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
                    if (response.data.createUser.errors > 0) {
                        console.log(response.data.createUser.errors);
                    } else {
                        const login = await this.forceLogin();
                        if (login && this.$route.path !== '/') {
                            this.$router.push('/');
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
            const token = await response.data.login.token
            const headers = { Authorization: token };
            this.toggleAuthentication();
            await onLogin(createProvider({}, headers), token);
            return response.data.login === null ? false : true;
        }
    },
    computed: {
        ...mapState(['isAuthenticated']),
    },
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
    /* display: none; */
}
</style>