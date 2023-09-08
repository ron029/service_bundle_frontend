import Vue from 'vue';
import VueRouter from 'vue-router';
import LoginPage from '@/views/LoginPage.vue';
import SignupPage from '@/views/SignupPage.vue';
import HomePage from '@/views/HomePage.vue';
import MerchantPage from '@/views/MerchantPage.vue';
import BookingPage from '@/views/BookingPage.vue';
import ServicePage from '@/views/ServicePage.vue';
import ServiceEdit from '@/views/ServiceEdit.vue';
import ServiceNew from '@/views/ServiceNew.vue';
import ServiceCategoryPage from '@/views/ServiceCategoryPage.vue';
import ServiceDetails from '@/components/ServiceDetails.vue';
import TimeSlotDetails from '@/components/ServiceDetails.vue';
import CartPage from '@/components/CartPage.vue';
import CheckoutPage from '@/components/CheckoutPage.vue';
import CustomerBookingPage from '@/components/CustomerBookingPage.vue';
import RegisteredPage from '@/components/RegisteredPage.vue';
import BookingManager from '@/views/BookingManager.vue';
import SignupEntrepPage from '@/views/SignupEntrepPage.vue';
import store from '@/store';

Vue.use(VueRouter);

const routes = [
  { path: '/login', component: LoginPage },
  { path: '/signup', component: SignupPage },
  { path: '/', component: HomePage },
  { path: '/merchant', component: MerchantPage },
  { path: '/booking', component: BookingPage },
  { path: '/services', component: ServicePage },
  { path: '/service_categories', component: ServiceCategoryPage},
  { path: '/services/new', component: ServiceNew },
  { path: '/services/:id/edit', component: ServiceEdit },
  { path: '/checkout', component: CheckoutPage },
  { path: '/cart', component: CartPage },
  { path: '/customer/booking', component: CustomerBookingPage },
  { path: '/registered', component: RegisteredPage },
  { path: '/booking_manager', component: BookingManager },
  { path: '/signup_entrepreneur', component: SignupEntrepPage },
  {
    path: '/service_categories/:categoryId',
    name: 'services',
    component: ServicePage,
    props: true
  },
  {
    path: '/service_categories/:categoryId/services/:serviceId',
    name: 'service-details',
    component: ServiceDetails,
    props: true
  },
  {
    path: '/service_categories/:categoryId/services/:serviceId/time_slots/:timeSlotId',
    name: 'time-slot-details',
    component: TimeSlotDetails,
    props: true
  }
  
];

const router = new VueRouter({
  routes,
  mode: 'history',
});

router.beforeEach((to, from, next) => {
  const isAuthenticated = store.state.isAuthenticated;

  if (to.path === '/logout') {
    store.commit('clearAuthentication');
    next('/login');
  } else if (!isAuthenticated && !['/login', '/signup', '/signup_entrepreneur'].includes(to.path)) {
    console.log('The current status of isAuthenticated store is', isAuthenticated)
    next('/login');
  } else {
    next();
  }
});

export default router;
