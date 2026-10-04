import { createWebHistory, createRouter } from 'vue-router'
import HomeView from "@/views/home/HomeView.vue";
import SchoolsView from "@/views/schools/SchoolsView.vue";
import StatisticsView from "@/views/statistics/StatisticsView.vue";
import CompareView from "@/views/compare/CompareView.vue";
import MapView from "@/views/map/MapView.vue";
import SchoolDetailView from "@/views/schools/SchoolDetailView.vue";

const routes = [
    { path: '/', component: HomeView },
    { path: '/schools', component: SchoolsView },
    { path: '/schools/:slug', component: SchoolDetailView },
    { path: '/statistics', component: StatisticsView },
    { path: '/compare', component: CompareView },
    { path: '/map', component: MapView },
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router
