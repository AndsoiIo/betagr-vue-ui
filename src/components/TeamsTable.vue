<template>
    <tbody>
    <tr
        v-if="teams && teams.length"
        v-for="team in teams"
        v-on:click="isSelect = team.team_id; $emit('select-related-team', team.team_id)"
        :class="{'select': isSelect == team.team_id}"
    >
        <td>{{ team.team_id }}</td>
        <td>{{ team.name }}</td>
        <td>{{ new Date(team.created_on).toLocaleString() }}</td>
        <td>
            {{ team.status }}
            <i class="material-icons"
               v-if="isSelect == team.team_id">
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
               isSelect: null,
            }
        },
    }
</script>

<style scoped>
    .status-approved {
        background-color: aquamarine;
    }
    .status-approved {
        background-color: bisque;
    }
    .select {
        background-color: #007bff !important;
        color: aliceblue !important;
    }

</style>