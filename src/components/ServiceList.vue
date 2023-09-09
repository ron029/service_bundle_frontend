<template>
  <div>
    <h2>Services</h2>
    <ApolloQuery :query="require('@/graphql/AdminService.gql')">
      <template v-slot="{ result: { data, loading } }">
        <div v-if="loading">Loading...</div>
        <div v-else>
          <table class="table">
            <thead>
              <tr>
                <th>Category Name</th>
                <th>Description</th>
                <th>Time Slots</th>
                <th>Image</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in data.serviceAdmin" :key="item.id">
                <td>{{ item.serviceCategoryId.name }}</td>
                <td>{{ item.description }}</td>
                <td>
                  <table>
                    <tr>
                      <th>date</th>
                      <th>start time</th>
                      <th>end time</th>
                    </tr>
                    <tr v-for="time in item.timeSlot" :key="time.id">
                      <td>{{ time.date }}</td>
                      <td>{{ time.startTime }}</td>
                      <td>{{ time.endTime }}</td>
                    </tr>
                  </table>
                </td>
                <td><img :src="item.image" :alt=item.category_name style="width: 200px; height: 150px;"></td>
                <td>
                  <router-link :to="{ path: '/services/' + item.id + '/edit' }" class="btn btn-warning"> Edit </router-link>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </template>
    </ApolloQuery>
  </div>
</template>

<script>
export default {
  name: 'ServiceList',
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
</style>