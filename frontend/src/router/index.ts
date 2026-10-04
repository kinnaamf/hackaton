import { createWebHistory, createRouter } from 'vue-router'
import HomeView from "@/views/home/HomeView.vue";
import SchoolsView from "@/views/schools/SchoolsView.vue";
import StatisticsView from "@/views/statistics/StatisticsView.vue";
import CompareView from "@/views/compare/CompareView.vue";
import MapView from "@/views/map/MapView.vue";
import SchoolDetailView from "@/views/schools/SchoolDetailView.vue";
import InfoView from "@/views/info/InfoView.vue";

const routes = [
    { path: '/', component: HomeView },
    { path: '/schools', component: SchoolsView, meta: { title: 'Școli auto | Path Drive' } },
    { path: '/schools/:slug', component: SchoolDetailView },
    { path: '/statistics', component: StatisticsView, meta: { title: 'Statistici | Path Drive' } },
    { path: '/compare', component: CompareView, meta: { title: 'Compară școli | Path Drive' } },
    { path: '/map', component: MapView, meta: { title: 'Hartă | Path Drive' } },
    { path: '/methodology', component: InfoView, meta: { page: 'methodology', title: 'Metodologie | Path Drive' } },
    { path: '/how-it-works', component: InfoView, meta: { page: 'how-it-works', title: 'Cum funcționează | Path Drive' } },
    { path: '/data', component: InfoView, meta: { page: 'data', title: 'Despre date | Path Drive' } },
    { path: '/faq', component: InfoView, meta: { page: 'faq', title: 'Întrebări frecvente | Path Drive' } },
    { path: '/about', component: InfoView, meta: { page: 'about', title: 'Despre proiect | Path Drive' } },
    { path: '/contact', component: InfoView, meta: { page: 'contact', title: 'Contact | Path Drive' } },
    { path: '/privacy', component: InfoView, meta: { page: 'privacy', title: 'Politica de confidențialitate | Path Drive' } },
    { path: '/terms', component: InfoView, meta: { page: 'terms', title: 'Termeni și condiții | Path Drive' } },
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

router.afterEach((to) => {
    document.title = typeof to.meta.title === 'string' ? to.meta.title : 'Path Drive'
})

export default router
