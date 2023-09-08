// store/index.js
import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

const isAuthenticated = localStorage.getItem('isAuthenticated') === 'true';

export default new Vuex.Store({
  state: {
    isAuthenticated,
    userRole: null,
  },
  
  mutations: {
    setAuthenticated(state, isAuthenticated) {
      state.isAuthenticated = isAuthenticated;
      localStorage.setItem('isAuthenticated', isAuthenticated);
    },
    setUserRole(state, userRole) {
      state.userRole = userRole; // Set the user role in the store
      // Optionally, you can save the user role to localStorage if needed
      localStorage.setItem('userRole', userRole);
    },
    clearAuthentication(state) {
      state.isAuthenticated = false;
      localStorage.removeItem('isAuthenticated');
    },
    clearUserRole(state) {
      // Set the userRole state to null to clear the role
      state.userRole = null;
    },
  },
});
