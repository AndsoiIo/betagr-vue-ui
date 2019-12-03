<!-- Template -->
<template>
  <div id="app">
    <!-- Modal window -->
    <div v-if="modalShow" class="modal fade show" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Sign In</h5>
            <button @click="modalShow = false" type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body text-left">
            <p>Enter your credential to get the session token</p>
            <form>
              <div class="form-group">
                <input
                        type="text"
                        class="form-control"
                        id="Username"
                        placeholder="Username"
                        v-model="username"
                >
              </div>
              <div class="form-group">
                <input
                        type="password"
                        class="form-control"
                        id="Password"
                        placeholder="Password"
                        v-model="password"
                >
              </div>
              <div v-if="signInErrors">
                <div class="alert alert-danger" role="alert">
                  {{ signInErrors }}
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button @click="signIn()" type="button" class="btn btn-primary">Sign In</button>
            <button @click="modalShow = false" type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="modalShow" class="modal-backdrop fade show"></div>
    <!-- /Modal window -->
    <nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0">
      <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">BetAgr</a>
      <input
              class="form-control form-control-dark w-100"
              type="text"
              placeholder="Search"
              aria-label="Search"
              v-model="search"
      >
      <ul class="navbar-nav px-3">
        <li class="nav-item text-nowrap">
          <a
                v-on:click="modalShow = true"
                class="nav-link" href="#"
          >
            Sign In
          </a>
        </li>
        <li class="nav-item text-nowrap">
          <a class="nav-link" href="#">Sign out</a>
        </li>
      </ul>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
          <div class="sidebar-sticky">
            <ul class="nav d-flex flex-column">
              <li class="nav-item">
                <a class="nav-link active" href="#">
                  <i class="material-icons">dashboard</i>
                  Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">
                  <i class="material-icons">layers</i>
                  Aggregator
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">
                  <i class="material-icons">insert_chart</i>
                  Parser
                </a>
              </li>
            </ul>
          </div>
        </nav>

        <TabsTeamsTable
          v-on:select-related-team="selectRelatedTeam"
        />

        <RealTeamsList
          v-on:select-real-team="selectRealTeam"
          v-on:approve-team="approveTeam"
          v-on:moderate-team="moderateTeam"
        />

      </div>
    </div>
  </div>
</template>

<!-- Script -->
<script>
  import axios from 'axios';
  import TabsTeamsTable from "./components/TabsTeamsTable";
  import RealTeamsList from "./components/RealTeamsList";

  const dashboardHost = process.env.DASHBOARD_API_HOST || 'localhost';
  const dashboardPort = process.env.DASHBOARD_API_PORT || 5050;
  let dashboardUrl = (dashboardHost.indexOf('http://')+1 ? dashboardHost : 'http://'+dashboardHost)+':'+ dashboardPort + '/api/approve/teams/';

  const ssoHost = process.env.SSO_API_HOST || 'localhost';
  const ssoPort = process.env.SSO_API_PORT || 8000;
  let ssoUrl = (ssoHost.indexOf('http://')+1 ? ssoHost : 'http://'+ssoHost)+':'+ ssoPort + '/sign-in';
  // let ssoUrl = 'http://localhost:8080/';
  // let dashboardUrl = 'http://localhost:8080/api';

  export default {
    name: 'app',
    data() {
      return {
        selectedRealTeam: null,
        selectedRelatedTeam: null,
        modalShow: true,
        search: '',
        username: '',
        password: '',
        signInErrors: false,
        errors: [],
        userPermisions: [],
      }
    },
    components: {
      TabsTeamsTable,
      RealTeamsList,
    },
    methods: {
      selectRelatedTeam(id) {
        this.selectedRelatedTeam = this.selectedRelatedTeam == id ? null : id;
        console.log('Select Related Team ID: ' + this.selectedRelatedTeam)
      },
      selectRealTeam(id) {
        this.selectedRealTeam = id;
        console.log('Select Real Team ID: '+ this.selectedRealTeam)
      },
      async approveTeam() {
        if (this.selectedRealTeam && this.selectedRelatedTeam) {
          try {
            response = await axios.put(`${dashboardUrl}/${this.selectedRelatedTeam}`, {withCredentials: true, real_team_id: this.selectedRealTeam});
          } catch (e) {
            this.errors.push(e);
            console.log(e);
          }
        } else {
          console.log('You should select a Real Team and a Related Team.')
        }
        console.log(this.selectedRealTeam ? 'Approve team' : 'You should choose Real Team')
      },
      moderateTeam() {
        console.log(this.selectedRealTeam ? 'Approve team' : 'You should choose Real Team')
      },
      async signIn() {
        let response;
        if (this.username && this.password) {
          try {
            response = await axios.post(ssoUrl+'/sign-in', {username: this.username, password: this.password} );
          } catch (e) {
            this.signInErrors = e;
          }
          console.log(response);
          if (response && document.cookie.indexOf('session')+1) {
            localStorage.session = document.cookie.split('=')[1];
            console.log('+++++Receive session+++++\n', localStorage.session)
          }
          console.log("-----"+ response +"-----\n")
        }
      },
    },
  }
</script>

<!-- Style -->
<style>
  #app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
  }
  i.material-icons {
    vertical-align: bottom;
  }
  .sidebar-sticky li {
    text-align: left;
  }
  .modal {
    display: block;
  }
  .hide {
    display: none;
  }
</style>
