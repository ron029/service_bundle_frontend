<template>
    <div>
        <nav class="navbar navbar-expand-lg bg-body-tertiary">
            <div class="container-fluid">
                <router-link to="/merchant" v-if="isAuthenticated && this.get_role() == 'admin'" class="navbar-brand">ServiceBundle</router-link>
                <router-link to="/" v-else class="navbar-brand">ServiceBundle</router-link>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'admin'">
                        <span @click="currentShowPage('bookings')">Bookings &nbsp;&nbsp;</span>
                    </li>
                    <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'admin'">
                        <span @click="currentShowPage('services')">Services &nbsp;&nbsp;</span>
                    </li>
                    <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'admin'">
                        <span @click="currentShowPage('serviceCategories')">Service Categories &nbsp;&nbsp;</span>
                    </li>
                    <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'customer'">
                        <router-link class="nav-link" to="/cart">Cart</router-link>
                    </li>
                    <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'customer'">
                        <a class="nav-link" href="/customer/booking">Bookings</a>
                    </li>
                    <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'manager'">
                        <router-link class="nav-link" to="/registered">Registered</router-link>
                    </li>
                    <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'manager'">
                        <a href="/services" class="nav-link">Services</a>
                    </li>
                    <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'manager'">
                        <router-link class="nav-link" to="/service_categories">Service_Categories</router-link>
                    </li>
                    <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'manager'">
                        <router-link class="nav-link" to="/booking">Bookings1</router-link>
                    </li>
                    <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'manager'">
                        <router-link class="nav-link" to="/booking_manager">Bookings2</router-link>
                    </li>
                    <!-- <li class="nav-item dropdown"> -->
                        <!-- <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"> Dropdown </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">Action</a></li>
                            <li><a class="dropdown-item" href="#">Another action</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#">Something else here</a></li>
                        </ul> -->
                    <!-- </li> -->
                        <!-- <li class="nav-item d-flex"> -->
                        <!-- <a class="nav-link disabled " aria-disabled="true">Disabled</a> -->
                    <!-- </li> -->
                </ul>
                <ul class="navbar-nav" v-if="!isAuthenticated">
                    <li class="nav-item"><router-link class="nav-link" to="/login">Log in</router-link></li>
                    <li class="nav-item"><router-link class="nav-link" to="/signup">Sign up</router-link></li>
                </ul>
                <ul class="navbar-nav" v-else>
                    <li class="nav-item"><span @click="logout" class="nav-link logout" to="logout">Log out</span></li>
                </ul>
                </div>
            </div>
        </nav>
        <div v-if="this.get_role()=='admin'">
            <ServicePage
            v-if="currentPage === 'services'"
            v-on:showServiceNew="showServiceNewPage()"
            v-on:showEditPage="showServiceEdit($event)"
            :new_service_data="newService"
            :update_service_data="updateServiceDetails"
            :update_service_time_slot_data="updateServiceTimeSlotData"
            />
            <BookingPage v-else-if="currentPage === 'bookings'" />
            <ServiceCategoryPage v-else-if="currentPage === 'serviceCategories'" />
            <ServiceNew 
            v-else-if="showNew"
            v-on:newServiceAdded="getLatestService($event)"
            />
            <ServiceEdit 
            v-else
            :id_to_edit="serviceId"
            :index_to_edit="indexToEdit"
            v-on:updateServicePage="updateService($event)"
            v-on:updateTimeSlot="updateServiceTimeSlot($event)"
            />
        </div>
    </div>
</template>

<script>
import BookingPage from '@/views/BookingPage.vue';
import ServicePage from '@/views/ServicePage.vue';
import ServiceCategoryPage from '@/views/ServiceCategoryPage.vue';
import ServiceNew from '@/views/ServiceNew.vue';
import ServiceEdit from '@/views/ServiceEdit.vue';

import { mapState, mapMutations } from 'vuex';
import { createProvider, onLogout } from '@/vue-apollo';
import logout from '@/graphql/Logout.gql';
import store from '@/store';

export default {
    name: 'AppNavbar',
    data(){
        return {
            currentPage: 'bookings', // Initial page
            showNew: false,
            showedit: false,
            serviceId: 1,
            indexToEdit: 0,
            newService: [],
            updateServiceDetails: {},
            updateServiceTimeSlotData: {},
        }
    },
    components: {
        ServicePage,
        BookingPage,
        ServiceCategoryPage,
        ServiceNew,
        ServiceEdit
    },
    computed: {
        ...mapState(['isAuthenticated', 'userRole']),
    },
    methods: {
        updateServiceTimeSlot(data) {
            console.log("AppNavbar: received 'updateTimeSlot' emit from 'ServiceEdit', data: ", data);
            this.updateServiceTimeSlotData = data
        },
        updateService(data) {
            console.log('appnavbar: update service details: ', data);
            this.updateServiceDetails = data;
        },
        getLatestService(data) {
            this.newService = data;
            console.log('this is from appnavbar, the new service is: ', this.newService);
        },
        currentShowPage(page) {
            this.showNew = false;
            // this.showEdit = false;
            this.currentPage = page
        },
        showServiceEdit(params) {
            this.serviceId = parseInt(params.id);
            // this.showEdit = true;
            this.indexToEdit = params.index;
            this.showNew = false;
            this.currentPage = '';
            console.log('appnavbar: this is app nav, the service id to edit is: ', params.id, ' with index: ', params.index)
            console.log(typeof this.serviceId)
        },
        showServiceNewPage() {
            this.showNew = true; 
            this.currentPage = '';
            // this.showEdit = false;
        },
        get_role() {
            const userRole = localStorage.getItem('userRole');
            return userRole;
        },
        ...mapMutations(['clearAuthentication', 'setAuthenticated']),
        async logout() {
            try {
                await this.$apollo.mutate({
                    mutation: logout,
                });
                await onLogout(createProvider);
                this.setAuthenticated(false);
                this.clearAuthentication();
                this.updateUserRole(null);
                // store.commit('clearUserRole');

                if (this.$route.path !== '/login') this.$router.push('/login');
            } catch (error) {
                console.error('Error logging out:', error);
            }
        },
        updateUserRole(role) {
            // Call the mutation 'setUserRole' with a payload (userRole)
            store.commit('setUserRole', role); // Replace 'admin' with your actual user role data
        },
    },
    mounted(){
        console.log('the role in navbar is now', this.get_role())
        console.log('the role is now', this.userRole)
    }
}
</script>

<style>
.logout {
    cursor: pointer;
}
</style>