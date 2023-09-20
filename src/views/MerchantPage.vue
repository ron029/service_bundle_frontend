<template>
	<div class=""> </div>
</template>

<script>
import { mapState, mapMutations } from 'vuex';
import { createProvider, onLogout } from '@/vue-apollo';
import logout from '@/graphql/Logout.gql';
import store from '@/store';
export default {
  data() {
    return {
		showPage: '',
    }
  },
  name: 'MerchantPage',
  computed: {
        ...mapState(['isAuthenticated', 'userRole']),
    },
    methods: {
        get_role(){
            const userRole = localStorage.getItem('userRole');
            return userRole;
        },
        ...mapMutations(['clearAuthentication', 'setAuthenticated', 'clearUserRole', 'setUserRole']),
        async logout() {
            try {
                await this.$apollo.mutate({
                    mutation: logout,
                });
                await onLogout(createProvider);
                this.setAuthenticated(false);
                this.clearAuthentication();
                this.setUserRole(false)
                this.clearUserRole();
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

</style>
