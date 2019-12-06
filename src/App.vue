<template>
    <div id="app">
        <div v-if="modalShow" class="modal fade show" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Sign In</h5>
                        <button v-if="userPermissions.length" @click="modalShow = false" type="button" class="close" data-dismiss="modal" aria-label="Close">
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
                                        required
                                >
                            </div>
                            <div class="form-group">
                                <input
                                        type="password"
                                        class="form-control"
                                        id="Password"
                                        placeholder="Password"
                                        v-model="password"
                                        required
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
                        <button v-if="userPermissions.length" @click="modalShow = false" type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <div v-if="modalShow" class="modal-backdrop fade show"></div>
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
                <div role="main" class="col-md-6 pt-3 px-4">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Related Teams Table</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group mr-2">
                                <button type="button" class="btn btn-sm btn-outline-secondary"
                                        @click="updateTeams()">Update DB</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary"
                                        @click="toDisplayRelatedTeamsTables = []; fetchTeams()">Refresh</button>
                            </div>
                        </div>
                    </div>
                    <ul class="nav nav-tabs" id="myTab" role="tablist"
                        v-if="relatedTeamsTables.length">
                        <li class="nav-item" v-for="(tab, index) in toDisplayRelatedTeamsTables">
                            <a
                                    :class=" {active: showTabsIndex === index, 'nav-link':true} "
                                    :id="tab.title.split(' ').join('-') + '-tab'"
                                    data-toggle="tab"
                                    :href="'#'+tab.title.split(' ').join('-')"
                                    role="tab"
                                    :aria-controls="tab.title.split(' ').join('-')" :aria-selected="{'true': showTabsIndex === index}"
                                    @click="indexTab(index)"
                            >
                                {{ tab.title }}
                            </a>
                        </li>
                    </ul>
                    <div v-else>
                        <h4>Database is empty. Click 'Update DB' button.</h4>
                    </div>
                    <div class="tab-content" id="myTabContent">
                        <div
                                v-if="relatedTeamsTables.length"
                                v-for="(tab, index) in toDisplayRelatedTeamsTables"
                                :class="{'tab-pane fade scrolled': true, 'show active': showTabsIndex === index}"
                                :id="tab.title.split(' ').join('-')"
                                role="tabpanel"
                                :aria-labelledby="tab.title.split(' ').join('-')+'-tab'"
                        >
                            <div class="table-responsive">
                                <table class="table table-striped table-borderless">
                                    <thead class="thead-dark">
                                    <tr>
                                        <th>Title</th>
                                        <th>Created on</th>
                                        <th>Status</th>
                                        <th v-if="userPermissions.indexOf('approve')+1 > 0" >
                                            Real Team
                                        </th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr
                                            v-if="tab.teams && tab.teams.length"
                                            v-for="team in tab.teams"
                                            v-on:click="selectTeam = selectTeam === team.team_id ? null : team.team_id; selectRelatedTeam(selectTeam)"
                                            :class="[selectTeam === team.team_id ? 'select' : '', (team.status) ]"
                                            :key="team.team_id"
                                    >
                                        <td>{{ team.name }}</td>
                                        <td>{{ new Date(team.created_on).toLocaleString() }}</td>
                                        <td>
                                            {{ team.status || 'N/A' }}
                                        </td>
                                        <td v-if="userPermissions.indexOf('approve')+1 > 0">
                                            {{ team.real_team_id }}
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <RealTeamsList
                        v-bind:realTeamsList="realTeamsList"
                        v-bind:isAdmin="userPermissions.indexOf('approve')+1 > 0"
                        v-bind:isModerator="userPermissions.indexOf('moderate')+1 > 0"
                        v-on:select-real-team="selectRealTeam"
                        v-on:approve-team="approveTeam"
                        v-on:moderate-team="moderateTeam"
                />

            </div>
        </div>
    </div>
</template>
<script>
    import axios from 'axios';
    import RealTeamsList from "./components/RealTeamsList";

    const parserHost = process.env.VUE_APP_PARSER_API_HOST || 'localhost';
    const parserPort = process.env.VUE_APP_PARSER_API_PORT || 8000;
    let parserUrl = (parserHost.indexOf('http://')+1 ? parserHost : 'http://'+parserHost)+':'+ parserPort;

    const dashboardHost = process.env.VUE_APP_DASHBOARD_API_HOST || 'localhost';
    const dashboardPort = process.env.VUE_APP_DASHBOARD_API_PORT || 5050;
    let dashboardUrl = (dashboardHost.indexOf('http://')+1 ? dashboardHost : 'http://'+dashboardHost)+':'+ dashboardPort + '/api';

    const ssoHost = process.env.VUE_APP_SSO_API_HOST || 'localhost';
    const ssoPort = process.env.VUE_APP_SSO_API_PORT || 5000;
    let ssoUrl = (ssoHost.indexOf('http://')+1 ? ssoHost : 'http://'+ssoHost)+':'+ ssoPort;

    const aggregatorHost = process.env.VUE_APP_AGGREGATOR_API_HOST || 'localhost';
    const aggregatorPort = process.env.VUE_APP_AGGREGATOR_API_PORT || 3000;
    let aggregatorUrl = (aggregatorHost.indexOf('http://')+1 ? aggregatorHost : 'http://'+aggregatorHost)+':'+ aggregatorPort;

    const bettingDataHost = process.env.VUE_APP_BETTING_DATA_API_HOST || 'localhost';
    const bettingDataPort = process.env.VUE_APP_BETTING_DATA_API_PORT || 8000;
    let bettingDataUrl = (bettingDataHost.indexOf('http://')+1 ? bettingDataHost : 'http://'+bettingDataHost)+':'+ bettingDataPort;

    export default {
        name: 'app',
        data() {
            return {
                //app
                selectedRealTeam: null,
                selectedRelatedTeam: null,
                modalShow: null,
                search: '',
                username: '',
                password: '',
                signInErrors: false,
                errors: [],
                userPermissions: [],
                //tabs teams
                toDisplayRelatedTeamsTables: [],
                relatedTeamsTables: [],
                realTeamsList: [],
                realTeamID: null,
                showTabsIndex: 0,
                //real teams
                selectTeam: null,

            }
        },
        components: {
            RealTeamsList,
        },
        mounted:function(){
            this.isLogged();
            this.fetchTeams();
        },
        methods: {
            indexTab(index) {
                this.showTabsIndex = index;
                this.selectedRelatedTeam = null;
            },
            selectRelatedTeam(id) {
                this.selectedRelatedTeam = this.selectedRelatedTeam === id ? null : id;
                console.log('Select Related Team ID: ' + this.selectedRelatedTeam)
            },
            async selectRealTeam(id) {
                this.selectedRealTeam = this.selectedRelatedTeam === id ? null : id;
                if (this.selectedRealTeam && !this.selectedRelatedTeam) {
                    this.toDisplayRelatedTeamsTables = [];

                    let realTeam = this.realTeamsList.filter( team => {return team.real_team_id === id})[0];

                    let url = `${aggregatorUrl}/aggregate?team=${realTeam.name}`;
                    await axios({
                        method: 'get',
                        url: url,
                    })
                    .then((resp) => {
                        console.log('Request aggregator by link: '+url, '"Ok"');
                        delete resp.data['real_teams'];
                        for (let linkNumber in resp.data) {
                            let index = parseInt(linkNumber) - 1;
                            let filteredTeam = this.relatedTeamsTables[index].teams.filter(
                                team => { return resp.data[linkNumber].indexOf(team.name)+1 > 0 }
                            );

                            let siteName = this.relatedTeamsTables[index].title;
                            this.toDisplayRelatedTeamsTables.push({title: siteName, teams: filteredTeam});
                        }
                    })
                    .catch((e) => {
                        console.log(e.message)
                    });
                } else if(this.selectedRealTeam === null) {
                    this.toDisplayRelatedTeamsTables = this.relatedTeamsTables.slice();
                }
                console.log('Select Real Team ID: ' + this.selectedRealTeam)
            },

            async updateTeams() {
                await axios({
                    method: 'put',
                    url: `${bettingDataUrl}/links?data=teams`,
                })
                    .catch ((e) => {
                        this.errors.push(e);
                        console.log(e.message);
                    });
                console.log('Send Request to ', bettingDataUrl+'/links?data=teams');
            },

            async approveTeam() {
                if (!this.userPermissions.length) {
                    this.modalShow = true;
                    alert('You need to be logged!');
                }
                else if (this.selectedRelatedTeam) {
                    await axios({
                        method: 'patch',
                        url: `${dashboardUrl}/approve-team/${this.selectedRelatedTeam}`,
                        withCredentials: true,
                        data: {
                            real_team_id: this.selectedRealTeam,
                        }
                    })
                        .then((resp) => {
                            loop: for (let tab of this.relatedTeamsTables) {
                                for (let team of tab.teams) {
                                    if (team.team_id === this.selectedRelatedTeam) {
                                        team.status = 'approved';
                                        break loop;
                                    }
                                }
                            }
                            console.log('Team was approved...')
                        })
                        .catch((e) => {
                            this.errors.push(e);
                            if (e.response.status === 422) {
                                alert(e.message+ '\n\nIt seems like this teams is on another process stage. Please select another team.')
                            } else if (e.response.status === 404) {
                                alert(e.message+ '\n\nPlease select another team.')
                            } else if (e.response.status === 403) {
                                alert(e.message+ "\n\nYou do not have permission to approve team status.")
                            } else {
                                alert(e.message)
                            }
                        });
                }
                else {
                    console.log('You should select a Related Team.')
                }
            },

            async moderateTeam() {
                if (!this.userPermissions.length) {
                    this.modalShow = true;
                    alert('You need to be logged!');
                }
                else if (this.selectedRealTeam && this.selectedRelatedTeam) {
                    await axios({
                        method: 'patch',
                        url: `${dashboardUrl}/moderate-team/${this.selectedRelatedTeam}`,
                        withCredentials: true,
                        data: {
                            real_team_id: this.selectedRealTeam,
                        }
                    })
                        .then((resp) => {
                            loop: for (let tab of this.relatedTeamsTables) {
                                for (let team of tab.teams) {
                                    if (team.team_id === this.selectedRelatedTeam) {
                                        team.status = 'moderated';
                                        break loop;
                                    }
                                }
                            }
                            console.log('Team was moderated...')
                        })
                        .catch((e) => {
                            this.errors.push(e);
                            console.log(e);
                            if (e.response.status === 422) {
                                alert(e.message+ '\n\nIt seems like this teams is on another process stage, and not new. Please select another team.')
                            } else if (e.response.status === 404) {
                                alert(e.message+ '\n\nPlease select another team.')
                            } else if (e.response.status === 403) {
                                alert(e.message+ "\n\nYou do not have permission to moderate team status.")
                            } else {
                                alert(e.message)
                            }
                        })
                }
                else {
                    alert('You should select both the Real Team and the Related Team.');
                }
            },

            async signIn() {
                this.userPermissions = [];
                localStorage.clear();
                let response;
                if (this.username && this.password) {
                    try {
                        response = await axios({
                            method: 'post',
                            url: `${ssoUrl}/sign-in`,
                            withCredentials: true,
                            data: {
                                username: this.username,
                                password: this.password,
                            }
                        })
                    } catch (e) {
                        this.signInErrors = e;
                    }
                    if (response && document.cookie.indexOf('session') + 1) {
                        localStorage.setItem('session', document.cookie.split('=')[1]);
                        this.modalShow = false;
                        try {
                            response = await axios({
                                method: 'get',
                                url: `${ssoUrl}/get-permissions`,
                                withCredentials: true,
                            })
                        } catch (e) {
                            console.log(e);
                            alert(e.message)
                        }
                        this.userPermissions = this.userPermissions.concat(response.data.permissions);
                    }
                }
            },
            async isLogged() {
                await axios({
                    method: 'get',
                    url: `${ssoUrl}/get-permissions`,
                    withCredentials: true,
                })
                    .then((resp) => {
                        this.userPermissions = this.userPermissions.concat(resp.data.permissions);
                        console.log('Permission status: ', this.userPermissions.join())
                    })
                    .catch((e) => {
                        console.log(e.message);
                        this.modalShow = true;
                    });
            },
            async fetchTeams() {
                this.relatedTeamsTables = [];
                let url = `${aggregatorUrl}/aggregate`;
                await axios({
                    method: 'get',
                    url: url
                }).then((resp) => {
                    console.log('Request aggregator by link: '+url, '"Ok"');
                    this.realTeamsList = resp.data['real_teams'];
                    delete resp.data['real_teams'];
                    for (let siteIndex in resp.data) {
                        let firstObj = resp.data[siteIndex][0];
                        let siteName = firstObj.site_name;
                        this.relatedTeamsTables.push({title: siteName, teams: resp.data[siteIndex]});
                        this.toDisplayRelatedTeamsTables = this.relatedTeamsTables.slice()
                    }
                }).catch((e) => {
                    if (e.response) {
                        status = e.response.status;
                        console.log(e.message);
                        this.errors.push(e);
                    } else {
                        console.log(e)
                    }

                })
            }
        },
    }

</script>

<style scoped>
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
    .modal-backdrop.show {
        opacity: 1;
        background-color: ghostwhite;
        backdrop-filter: blur(10px) grayscale(100%);
    }
    .scrolled {
        overflow-y: auto;
        max-height: 520px;
    }
    tr:nth-child(2n+1).approved {
        background-color: rgba(90, 235, 190, 1) !important;
    }
    .approved {
        background-color: aquamarine !important;
    }
    tr:nth-child(2n+1).moderated {
        background-color: rgba(235, 208, 176, 1) !important;
    }
    .moderated {
        background-color: bisque !important;
    }
    tr.select,
    tr.select.approved,
    tr.select.moderated {
        background-color: #007bff !important;
        color: aliceblue !important;
    }
</style>