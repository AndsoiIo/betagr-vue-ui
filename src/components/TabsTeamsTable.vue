<template>
    <div role="main" class="col-md-6 pt-3 px-4">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Related Teams Table</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
                <div class="btn-group mr-2">
                    <button type="button" class="btn btn-sm btn-outline-secondary">Update DB</button>
                    <button type="button" class="btn btn-sm btn-outline-secondary">Refresh</button>
                </div>
            </div>
        </div>
        <ul class="nav nav-tabs" id="myTab" role="tablist">
            <li class="nav-item" v-for="(tab, index) in relatedTeamsTabs">
                <a
                    :class="{active: showTabsIndex == index, 'nav-link':true} "
                    :id="tab.title.split(' ').join('-') + '-tab'"
                    data-toggle="tab"
                    :href="'#'+tab.title.split(' ').join('-')"
                    role="tab"
                    :aria-controls="tab.title.split(' ').join('-')" :aria-selected="{'true': showTabsIndex == index}"
                >
                    {{ tab.title }}
                </a>
            </li>
        </ul>
        <div class="tab-content" id="myTabContent">
            <div
                    v-for="(tab, index) in relatedTeamsTabs"
                    :class="{'tab-pane fade scrolled': true, 'show active': showTabsIndex == index}"
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
                        </tr>
                        </thead>
                        <!--  TeamsTable  -->
                        <TeamsTable
                                v-bind:teams="tab.teams"
                                v-on:select-related-team="selectRelatedTeam"
                        />
                        <!--  If errors show message  -->
                        <tbody v-if="errors && errors.length">
                            <tr v-for="error in errors">
                                <td>{{ error }}</td>
                            </tr>
                        </tbody>

                    </table>
                </div>
            </div>
        </div>
    </div>

</template>

<script>
    import axios from 'axios';
    import TeamsTable from "./TeamsTable";

    const parserHost = process.env.PARSER_API_HOST || 'localhost';
    const parserPort = process.env.PARSER_API_PORT || 8000;

    let parserUrl = (parserHost.indexOf('http://')+1 ? parserHost : 'http://'+parserHost) + ':' + parserPort + '/parse-links/';

    export default {
        name: "TabsTeamsTable",
        data () {
            return {
                relatedTeamsTabs: [],
                realTeamID: null,
                errors: [],
                showTabsIndex: 0,
            }
        },
        components: {
            TeamsTable,
        },
        methods: {
            selectRelatedTeam(id) {
                this.$emit('select-related-team', id)
            }
        },
        async created() {

            let i = 0;
            let response = null;
            let status = 200;

            while (status == 200) {
                i = i + 1;
                let url = parserUrl+i+"?parse_by=teams";
                try {
                    response = await axios.get(url);
                    status = response.status;
                } catch (e) {
                    status = e.status;
                    this.errors.push(e);
                    break
                }
                if (response) {
                    console.log('Parse link: '+url);
                    let firstObjKey = Object.keys(response.data)[0];
                    let siteName = response.data[firstObjKey].site_name;
                    this.relatedTeamsTabs.push({title: siteName, teams: response.data});
                };
            }
        },
    }
</script>

<style scoped>

    .scrolled {
        overflow-y: auto;
        max-height: 520px;
    }

</style>