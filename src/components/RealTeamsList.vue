<template>
    <div class="col-md-4 mr-0 mt-3">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Real Teams</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
            </div>
        </div>
        <div class="opaque text-left">
            <button type="button" class="btn btn-sm btn-outline-success"
                    v-on:click="$emit('approve-team')">Approve</button>

            <button type="button" class="btn btn-sm btn-outline-primary"
                    v-on:click="$emit('moderate-team')">Moderate</button>
        </div>

        <ul
                class="list-group scrolled"
                v-if="realTeamsList && realTeamsList.length"

        >
            <li :class="{'active': isSelect == team.real_team_id, ' list-group-item list-group-item-action pointer': true}"
                v-for="team in realTeamsList"
                v-on:click="isSelect = isSelect == team.real_team_id? null : team.real_team_id; $emit('select-real-team', isSelect)"
            >
                {{ team.name }}
            </li>
        </ul>

        <ul
                class="list-group"
                v-if="errors && errors.length"
                v-for="(index, error) in errors" :key="index"
        >
            <li class="list-group-item list-group-item-action warning pointer">
                {{ error.message }}
            </li>
        </ul>
    </div>
</template>

<script>
    import axios from 'axios';

    const parserHost = process.env.PARSER_API_HOST || 'localhost';
    const parserPort = process.env.PARSER_API_PORT || 8000;

    let parserUrl = (parserHost.indexOf('http://')+1 ? parserHost : 'http://'+parserHost) + ':' + parserPort + '/parse-links?parse_by=real_teams';

    let selectedTeam = null;

    export default {
        name: "RealTeamsList",
        data() {
            return {
                isSelect: null,
                realTeamsList: [],
                errors: [],
            }
        },
        async created() {

            try {
                const response = await axios.get(parserUrl);
                this.realTeamsList = response.data
            } catch (e) {
                this.errors.push(e)
            }
        },
    }
</script>

<style scoped>

    .scrolled {
        overflow-y: auto;
        max-height: 520px;
    }
    .pointer {
        cursor: pointer;
    }
    .opaque {
        height: 42px;
        width: 100%;
    }

</style>