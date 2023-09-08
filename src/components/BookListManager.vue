<template>
  <div>
    <ul class="nav nav-tabs" id="myTab" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active" id="home-tab" data-bs-toggle="tab" data-bs-target="#home-tab-pane" type="button" role="tab" aria-controls="home-tab-pane" aria-selected="true">All</button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile-tab-pane" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="false">Upcoming</button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="contact-tab" data-bs-toggle="tab" data-bs-target="#contact-tab-pane" type="button" role="tab" aria-controls="contact-tab-pane" aria-selected="false">Completed</button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="disabled-tab" data-bs-toggle="tab" data-bs-target="#disabled-tab-pane" type="button" role="tab" aria-controls="disabled-tab-pane" aria-selected="false">Cancelled</button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="mostbook-tab" data-bs-toggle="tab" data-bs-target="#mostbook-tab-pane" type="button" role="tab" aria-controls="disabled-tab-pane" aria-selected="false">Most Booked</button>
      </li>
    </ul>
    <div class="tab-content" id="myTabContent">
      <div class="tab-pane fade show active" id="home-tab-pane" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
        <ApolloQuery :query="require('../graphql/AdminCartItemAll.gql')">
          <template v-slot="{ result: { data, loading } }">
            <div v-if="loading">Loading...</div>
            <div v-else>
              <!-- Check if there are zero records -->
              <!-- <div v-if="data.adminCartItem.length === 0">
                <p>No records found.</p>
              </div> -->
                <table class="table">
                  <thead>
                    <tr>
                      <th>id</th>
                      <th>serviceName</th>
                      <th>userName</th>
                      <th>userLastname</th>
                      <th>date</th>
                      <th>time</th>
                      <th>status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="item in data.adminCartItem" :key="item.id">
                      <td>{{ item.id }}</td>
                      <td>{{ item.serviceName }}</td>
                      <td>{{ item.userName }}</td>
                      <td>{{ item.userLastname }}</td>
                      <td>{{ item.date }}</td>
                      <td>{{ item.time }}</td>
                      <td>{{ item.status }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </template>
        </ApolloQuery>
      </div>
      <div class="tab-pane fade" id="profile-tab-pane" role="tabpanel" aria-labelledby="profile-tab" tabindex="0">
        <ApolloQuery :query="require('../graphql/AdminCartItemUpcoming.gql')">
          <template v-slot="{ result: { data, loading } }">
            <div v-if="loading">Loading...</div>
            <div v-else>
              <!-- Check if there are zero records -->
              <!-- <div v-if="data.adminCartItem.length === 0">
                <p>No records found.</p>
              </div> -->
                <table class="table">
                  <thead>
                    <tr>
                      <th>id</th>
                      <th>serviceName</th>
                      <th>userName</th>
                      <th>userLastname</th>
                      <th>date</th>
                      <th>time</th>
                      <th>status</th>
                      <th>action</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="item in data.adminCartItem" :key="item.id">
                      <td>{{ item.id }}</td>
                      <td>{{ item.serviceName }}</td>
                      <td>{{ item.userName }}</td>
                      <td>{{ item.userLastname }}</td>
                      <td>{{ item.date }}</td>
                      <td>{{ item.time }}</td>
                      <td>{{ item.status }}</td>
                      <td>
                        <span @click="this.action_item(item, 'completed')" class="btn btn-success">complete</span>
                        <span @click="this.action_item(item, 'cancelled')" class="btn btn-danger">cancelled</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </template>
        </ApolloQuery>
      </div>
      <div class="tab-pane fade" id="contact-tab-pane" role="tabpanel" aria-labelledby="contact-tab" tabindex="0">
        <ApolloQuery :query="require('../graphql/AdminCartItemCompleted.gql')">
          <template v-slot="{ result: { data, loading } }">
            <div v-if="loading">Loading...</div>
            <div v-else>
              <!-- Check if there are zero records -->
              <!-- <div v-if="data.adminCartItem.length === 0">
                <p>No records found.</p>
              </div> -->
                <table class="table">
                  <thead>
                    <tr>
                      <th>id</th>
                      <th>serviceName</th>
                      <th>userName</th>
                      <th>userLastname</th>
                      <th>date</th>
                      <th>time</th>
                      <th>status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="item in data.adminCartItem" :key="item.id">
                      <td>{{ item.id }}</td>
                      <td>{{ item.serviceName }}</td>
                      <td>{{ item.userName }}</td>
                      <td>{{ item.userLastname }}</td>
                      <td>{{ item.date }}</td>
                      <td>{{ item.time }}</td>
                      <td>{{ item.status }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </template>
        </ApolloQuery>
      </div>
      <div class="tab-pane fade" id="disabled-tab-pane" role="tabpanel" aria-labelledby="disabled-tab" tabindex="0">
        <ApolloQuery :query="require('../graphql/AdminCartItemCancelled.gql')">
          <template v-slot="{ result: { data, loading } }">
            <div v-if="loading">Loading...</div>
            <div v-else>
              <!-- Check if there are zero records -->
              <!-- <div v-if="data.adminCartItem.length === 0">
                <p>No records found.</p>
              </div> -->
                <table class="table">
                  <thead>
                    <tr>
                      <th>id</th>
                      <th>serviceName</th>
                      <th>userName</th>
                      <th>userLastname</th>
                      <th>date</th>
                      <th>time</th>
                      <th>status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="item in data.adminCartItem" :key="item.id">
                      <td>{{ item.id }}</td>
                      <td>{{ item.serviceName }}</td>
                      <td>{{ item.userName }}</td>
                      <td>{{ item.userLastname }}</td>
                      <td>{{ item.date }}</td>
                      <td>{{ item.time }}</td>
                      <td>{{ item.status }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </template>
        </ApolloQuery>
      </div>
      <div class="tab-pane fade" id="mostbook-tab-pane" role="tabpanel" aria-labelledby="disabled-tab" tabindex="0">
        <ApolloQuery :query="require('../graphql/AdminCartItemCountService.gql')">
          <template v-slot="{ result: { data, loading } }">
            <div v-if="loading">Loading...</div>
            <div v-else>
              <!-- Check if there are zero records -->
              <!-- <div v-if="data.adminCartItem.length === 0">
                <p>No records found.</p>
              </div> -->
                <table class="table">
                  <thead>
                    <tr>
                      <th>count</th>
                      <th>serviceName</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="item in data.adminCartItemCountService" :key="item.id">
                      <td>{{ item.count }}</td>
                      <td>{{ item.service.name }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </template>
        </ApolloQuery>
      </div>
    </div>
  </div>
</template>

<script>
import UPDATE_STATUS_ADMIN_CART_ITEM from '@/graphql/UpdateStatusAdminCartItem.gql';
export default {
  name: 'AppFooter',
  methods: {
    async action_item(id, action) {
      let status = 0;
      if (action == 'cancelled') status = 3
      if (action == 'completed') status = 4
      const response = await this.$apollo.mutate({
        mutation: UPDATE_STATUS_ADMIN_CART_ITEM,
        variables: {
          id: id,
          status: status
        }
      })
      console.log(response)
    }
  }

}
</script>

<style>

</style>