<template>
    <tbody>
    <tr
        v-if="teams && teams.length"
        v-for="team in teams"
        v-on:click="selectTeam = selectTeam == team.team_id? null:team.team_id; $emit('select-related-team', selectTeam)"
        :class="[selectTeam == team.team_id ? 'select' : '', true ? team.status : '' ]"
    >
        <td>{{ team.name }}</td>
        <td>{{ new Date(team.created_on).toLocaleString() }}</td>
        <td>
            {{ team.status || 'N/A' }}
            <i class="material-icons"
               v-if="selectTeam == team.team_id">
                double_arrow
            </i>
        </td>
    </tr>
    </tbody>
</template>

<script>

    export default {
        name: "TabsTeamsTable",
        props: {
            teams: {
                type: Array,
                required: true,
            }
        },
        data() {
            return {
               selectTeam: null,
            }
        },
    }
</script>

<style scoped>
    .approved {
        background-color: aquamarine;
    }
    .moderated {
        background-color: bisque !important;
    }
    .select {
        background-color: #007bff !important;
        color: aliceblue !important;
    }

</style>