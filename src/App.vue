<!-- Template -->
<template>
  <div id="app">
    <nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0">
      <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">BetAgr</a>
      <input class="form-control form-control-dark w-100" type="text" placeholder="Search" aria-label="Search">
      <ul class="navbar-nav px-3">
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
  import TabsTeamsTable from "./components/TabsTeamsTable";
  import RealTeamsList from "./components/RealTeamsList";

  export default {
    name: 'app',
    data() {
      return {
        selectedRealTeam: null,
        selectedRelatedTeam: null,
      }
    },
    components: {
      TabsTeamsTable,
      RealTeamsList,
    },
    methods: {
      selectRelatedTeam(id) {
        this.selectedRealTeam = id;
      },
      selectRealTeam(id) {
        this.selectedRelatedTeam = id;
      },
      approveTeam() {
        console.log(this.selectedRealTeam ? 'Approve team' : 'You should choose Real Team')
      },
      moderateTeam() {
        console.log(this.selectedRealTeam ? 'Approve team' : 'You should choose Real Team')
      }
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
</style>
