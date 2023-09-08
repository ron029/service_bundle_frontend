import '@babel/polyfill';
import './styles/custom-bootstrap.scss';
import 'bootstrap';
import Vue from 'vue';
import App from './App.vue';
import router from './router';
import { createProvider } from './vue-apollo';
import store from './store';

Vue.config.productionTip = false

new Vue({
  store,
  router,
  apolloProvider: createProvider(),
  created() {
    const isAuthenticated = localStorage.getItem('isAuthenticated') === 'true';
    if (isAuthenticated) {
      this.$store.commit('setAuthenticated', true);
    }
  },
  render: h => h(App)
}).$mount('#app')