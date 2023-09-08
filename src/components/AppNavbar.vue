<template>
    <nav class="navbar navbar-expand-lg bg-body-tertiary">
        <div class="container-fluid">
            <router-link to="/" class="navbar-brand">ServiceBundle</router-link>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'admin'">
                    <router-link class="nav-link" to="/booking">Bookings</router-link>
                    <!-- <router-link to="/cinemas" class="nav-link">Cinemas</router-link> -->
                    <!-- <a class="nav-link" href="#">Link</a> -->
                </li>
                <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'admin'">
                    <router-link class="nav-link" to="/services">Services</router-link>
                <!-- <router-link to="/movies" class="nav-link">Movies</router-link> -->
                <!-- <a class="nav-link" href="#">Link</a> -->
                </li>
                <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'admin'">
                    <router-link class="nav-link" to="/service_categories">Service Categories</router-link>
                <!-- <router-link to="/bookings" class="nav-link">Bookings</router-link> -->
                <!-- <a class="nav-link" href="#">Link</a> -->
                </li>
                <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'customer'">
                    <router-link class="nav-link" to="/cart">Cart</router-link>
                <!-- <router-link to="/screenings" class="nav-link">Screenings</router-link> -->
                <!-- <a class="nav-link" href="#">Link</a> -->
                </li>
                <!-- <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'customer'"> -->
                    <!-- <router-link class="nav-link" to="/checkout">Checkout</router-link> -->
                <!-- <router-link to="/screenings" class="nav-link">Screenings</router-link> -->
                <!-- <a class="nav-link" href="#">Link</a> -->
                <!-- </li> -->
                <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'customer'">
                    <a class="nav-link" href="/customer/booking">Bookings</a>
                <!-- <router-link to="/screenings" class="nav-link">Screenings</router-link> -->
                <!-- <a class="nav-link" href="#">Link</a> -->
                </li>
                <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'manager'">
                    <router-link class="nav-link" to="/registered">Registered</router-link>
                <!-- <router-link to="/screenings" class="nav-link">Screenings</router-link> -->
                <!-- <a class="nav-link" href="#">Link</a> -->
                </li>
                <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'manager'">
                    <a href="/services" class="nav-link">Services</a>
                <!-- <router-link to="/screenings" class="nav-link">Screenings</router-link> -->
                <!-- <a class="nav-link" href="#">Link</a> -->
                </li>
                <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'manager'">
                    <router-link class="nav-link" to="/service_categories">Service Categories</router-link>
                <!-- <router-link to="/screenings" class="nav-link">Screenings</router-link> -->
                <!-- <a class="nav-link" href="#">Link</a> -->
                </li>
                <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'manager'">
                    <router-link class="nav-link" to="/booking">Bookings1</router-link>
                <!-- <router-link to="/screenings" class="nav-link">Screenings</router-link> -->
                <!-- <a class="nav-link" href="#">Link</a> -->
                </li>
                <li class="nav-item" v-if="isAuthenticated && this.get_role() == 'manager'">
                    <router-link class="nav-link" to="/booking_manager">Bookings2</router-link>
                <!-- <router-link to="/screenings" class="nav-link">Screenings</router-link> -->
                <!-- <a class="nav-link" href="#">Link</a> -->
                </li>
                <!-- <li class="nav-item dropdown"> -->
                <!-- <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    Dropdown
                </a>
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
</template>

<script>
import { mapState, mapMutations } from 'vuex';
import { createProvider, onLogout } from '@/vue-apollo';
import logout from '@/graphql/Logout.gql';
import store from '@/store';

export default {
    name: 'AppNavbar',
    computed: {
        ...mapState(['isAuthenticated', 'userRole']),
    },
    methods: {
        get_role(){
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
                store.commit('clearUserRole');

                if (this.$route.path !== '/login') this.$router.push('/login');
            } catch (error) {
                console.error('Error logging out:', error);
            }
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