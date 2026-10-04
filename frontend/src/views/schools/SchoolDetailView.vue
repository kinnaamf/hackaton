<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { CheckCircle2, ChevronLeft, MapPin, Star, Users, Car, Phone, Mail, ExternalLink } from '@lucide/vue'
import { useRoute } from 'vue-router'
import { getSchool, getSchoolPerformance, getSchoolReviews } from '@/api/schools'
import { addSchoolToCompare, comparedSchools } from '@/stores/compare'
import type { Performance } from '@/types/api'
import type { SchoolProfile, SchoolReview } from '@/types/school-profile'
import { schoolIdFromSlug } from '@/utils/school'
import SchoolMapPreview from '@/components/schools/SchoolMapPreview.vue'

const route = useRoute()
const school = ref<SchoolProfile | null>(null)
const performance = ref<Performance | null>(null)
const reviews = ref<SchoolReview[]>([])
const loading = ref(true)
const error = ref(false)
const toast = ref('')

const stats = computed(() => school.value?.stats[0] ?? null)
const months = ['Ian', 'Feb', 'Mar', 'Apr', 'Mai', 'Iun', 'Iul', 'Aug', 'Sep', 'Oct', 'Noi', 'Dec']
const points = computed(() => {
  const entries = performance.value?.performance ?? []
  const make = (key: 'theory' | 'practice') => entries.map((entry, index) => {
    const x = 4 + (index * 92 / Math.max(entries.length - 1, 1))
    const value = entry[key] ?? 0
    return `${x},${94 - value * 0.72}`
  }).join(' ')
  return { theory: make('theory'), practice: make('practice') }
})

function percent(value: number | null | undefined) {
  return Number.isFinite(value) ? `${Math.round(value!)}%` : '—'
}

function locationLabel() {
  return [school.value?.city, school.value?.address].filter(Boolean).join(', ') || 'Vezi pe hartă'
}

function mapPath() {
  if (!school.value) return '/map'
  return { path: '/map', query: { school: String(school.value.id) } }
}

function addToCompare() {
  if (!school.value) return
  const result = addSchoolToCompare({
    id: school.value.id, name: school.value.shortName || school.value.name, verified: school.value.verified,
    city: school.value.city ?? '—', address: school.value.address ?? '—', categories: school.value.categories.map((item) => item.code),
    hasOwnTrainingGround: school.value.hasOwnTrainingGround, theoryPassRate: stats.value?.theoryPassRate ?? 0,
    practicePassRate: stats.value?.practicePassRate ?? 0, firstTryPassRate: stats.value?.practiceFirstTryRate ?? 0,
    rank: stats.value?.rank ?? 0, rating: school.value.rating.overall ?? 0, reviewsCount: school.value.rating.reviewsCount,
    candidatesCount: stats.value?.candidatesCount ?? 0, priceFrom: Math.min(...school.value.categories.map((item) => item.price ?? Infinity)),
  })
  if (result === 'full') toast.value = 'Poți compara maximum 3 școli.'
  setTimeout(() => { toast.value = '' }, 3000)
}

async function loadSchool() {
  const slug = Array.isArray(route.params.slug) ? route.params.slug[0] : route.params.slug
  const schoolId = slug ? schoolIdFromSlug(slug) : null
  if (!schoolId) { error.value = true; loading.value = false; return }

  loading.value = true
  error.value = false
  try {
    const detail = await getSchool(schoolId)
    school.value = detail
    const selectedStats = detail.stats[0]

    try {
      reviews.value = (await getSchoolReviews(schoolId)).items
    } catch {
      reviews.value = []
    }

    try {
      performance.value = await getSchoolPerformance(schoolId, selectedStats?.category ?? 'B', selectedStats?.year)
    } catch {
      performance.value = null
    }
  } catch {
    error.value = true
  } finally {
    loading.value = false
  }
}

watch(() => route.params.slug, loadSchool, { immediate: true })
</script>

<template>
  <section class="py-8 md:py-12">
    <RouterLink to="/schools" class="inline-flex items-center gap-1 text-sm font-semibold text-slate-500 transition-colors hover:text-purple-800"><ChevronLeft class="size-4" /> Înapoi la școli</RouterLink>

    <p v-if="loading" class="mt-10 rounded-2xl bg-white p-8 text-slate-500">Se încarcă profilul școlii…</p>
    <div v-else-if="error || !school" class="mt-10 rounded-2xl border border-dashed border-slate-300 bg-white p-8 text-center"><h1 class="text-xl font-semibold">Școala nu a fost găsită</h1><RouterLink to="/schools" class="mt-4 inline-block text-sm font-semibold text-purple-800">Vezi toate școlile</RouterLink></div>

    <template v-else>
      <div class="mt-6 flex flex-col justify-between gap-5 border-b border-slate-200 pb-7 md:flex-row md:items-start">
        <div>
          <p class="text-xs font-semibold uppercase tracking-wider text-purple-800">Profil școală auto</p>
          <div class="mt-2 flex flex-wrap items-center gap-2"><h1 class="text-3xl font-semibold text-slate-900">{{ school.shortName || school.name }}</h1><span v-if="school.verified" class="inline-flex items-center gap-1 text-xs font-semibold text-emerald-600"><CheckCircle2 class="size-4" /> Date verificate</span></div>
          <RouterLink :to="mapPath()" class="mt-3 inline-flex items-center gap-2 text-sm text-slate-500 hover:text-purple-800"><MapPin class="size-4" />{{ locationLabel() }}</RouterLink>
          <div class="mt-4 flex flex-wrap gap-2"><span v-for="item in school.categories" :key="item.code" class="rounded-md bg-purple-50 px-2.5 py-1 text-xs font-bold text-purple-800">{{ item.code }}</span><span v-if="school.hasOwnTrainingGround" class="rounded-md bg-slate-100 px-2.5 py-1 text-xs font-semibold text-slate-600">Poligon propriu</span></div>
        </div>
        <div class="flex flex-wrap gap-2"><button type="button" class="h-10 rounded-lg border border-slate-700 px-4 text-sm font-semibold text-slate-700 hover:bg-slate-50" @click="addToCompare">{{ comparedSchools.some((item) => item.id === school!.id) ? 'Adăugată' : '+ Compară' }}</button><RouterLink :to="mapPath()" class="inline-flex h-10 items-center gap-2 rounded-lg bg-purple-800 px-4 text-sm font-semibold !text-white transition-all duration-200 hover:bg-purple-900"><MapPin class="size-4" /> Vezi pe hartă</RouterLink></div>
      </div>

      <div v-if="stats" class="mt-5 flex items-center gap-4 rounded-2xl border border-purple-100 bg-purple-50 px-5 py-4"><strong class="text-3xl text-purple-800">#{{ stats.rank ?? '—' }}</strong><div><strong class="text-sm text-slate-800">în categoria {{ stats.category }}</strong><p class="text-xs text-slate-500">Clasament {{ stats.year }}</p></div></div>

      <div class="mt-9 flex items-end justify-between gap-4"><div><p class="text-xs font-semibold uppercase tracking-wider text-purple-800">Categoria {{ stats?.category ?? '—' }} · {{ stats?.year ?? '—' }}</p><h2 class="mt-2 text-2xl font-semibold text-slate-900">Indicatori principali</h2></div></div>
      <div class="mt-5 grid overflow-hidden rounded-2xl border border-slate-200 bg-white sm:grid-cols-2 lg:grid-cols-5">
        <div v-for="item in [{label:'Promovare teorie', value:percent(stats?.theoryPassRate)}, {label:'Promovare practică', value:percent(stats?.practicePassRate)}, {label:'Teorie din prima', value:percent(stats?.theoryFirstTryRate)}, {label:'Practică din prima', value:percent(stats?.practiceFirstTryRate)}, {label:'Candidați', value:stats?.candidatesCount ?? '—'}]" :key="item.label" class="border-b border-r border-slate-200 p-5 last:border-r-0 lg:border-b-0"><strong class="text-2xl text-purple-800">{{ item.value }}</strong><p class="mt-2 text-xs text-slate-500">{{ item.label }}</p></div>
      </div>

      <div class="mt-8 grid gap-6 lg:grid-cols-[minmax(0,1.6fr)_minmax(280px,0.8fr)]">
        <article v-if="performance?.performance.length" class="rounded-2xl border border-slate-200 bg-white p-5"><p class="text-xs font-semibold uppercase tracking-wider text-purple-800">Performanță lunară</p><h2 class="mt-2 text-xl font-semibold">Evoluția rezultatelor</h2><svg class="mt-6 h-48 w-full" viewBox="0 0 100 100" preserveAspectRatio="none"><path v-for="line in [20,45,70,94]" :key="line" :d="`M 4 ${line} H 96`" stroke="#e2e8f0" stroke-width="0.6" /><polyline :points="points.theory" fill="none" stroke="#6b21a8" stroke-width="1.3" vector-effect="non-scaling-stroke" /><polyline :points="points.practice" fill="none" stroke="#059669" stroke-width="1.3" vector-effect="non-scaling-stroke" /></svg><div class="mt-2 grid grid-cols-12 gap-1 text-center text-[11px] text-slate-400"><span v-for="month in months" :key="month" class="min-w-0">{{ month }}</span></div><div class="mt-4 flex gap-4 text-xs text-slate-500"><span class="inline-flex items-center gap-1"><i class="size-2 rounded-full bg-purple-800" />Promovare teorie</span><span class="inline-flex items-center gap-1"><i class="size-2 rounded-full bg-emerald-600" />Promovare practică</span></div></article>
        <article class="rounded-2xl border border-slate-200 bg-white p-5"><p class="text-xs font-semibold uppercase tracking-wider text-purple-800">Analiză</p><h2 class="mt-2 text-xl font-semibold">Datele școlii</h2><dl class="mt-6 space-y-4 text-sm"><div class="flex justify-between gap-4"><dt class="text-slate-500">Rating</dt><dd class="font-semibold"><Star class="mr-1 inline size-4 fill-amber-400 text-amber-400" />{{ school.rating.overall ?? '—' }} / 5</dd></div><div class="flex justify-between gap-4"><dt class="text-slate-500">Recenzii</dt><dd class="font-semibold">{{ school.rating.reviewsCount }}</dd></div><div class="flex justify-between gap-4"><dt class="text-slate-500">Instructori activi</dt><dd class="font-semibold">{{ school.instructorsCount }}</dd></div><div class="flex justify-between gap-4"><dt class="text-slate-500">Vehicule active</dt><dd class="font-semibold">{{ school.vehiclesCount }}</dd></div></dl><div class="mt-6 border-t border-slate-100 pt-5 text-sm text-slate-600"><a v-if="school.phone" :href="`tel:${school.phone}`" class="flex items-center gap-2 hover:text-purple-800"><Phone class="size-4" />{{ school.phone }}</a><a v-if="school.email" :href="`mailto:${school.email}`" class="mt-3 flex items-center gap-2 hover:text-purple-800"><Mail class="size-4" />{{ school.email }}</a></div></article>
      </div>

      <div class="mt-10"><p class="text-xs font-semibold uppercase tracking-wider text-purple-800">Oferta școlii</p><h2 class="mt-2 text-2xl font-semibold">Categorii și prețuri</h2><div class="mt-5 overflow-x-auto rounded-2xl border border-slate-200 bg-white"><table class="w-full min-w-[640px] text-left text-sm"><thead class="bg-slate-50 text-xs uppercase text-slate-500"><tr><th class="px-5 py-4">Categoria</th><th class="px-5 py-4">Preț</th><th class="px-5 py-4">Teorie</th><th class="px-5 py-4">Practică</th><th class="px-5 py-4">Durata</th></tr></thead><tbody><tr v-for="item in school.categories" :key="item.code" class="border-t border-slate-200"><td class="px-5 py-4 font-bold text-purple-800">{{ item.code }}</td><td class="px-5 py-4 font-semibold">{{ item.price == null ? '—' : item.price.toLocaleString('ro-MD') }} {{ item.currency ?? '' }}</td><td class="px-5 py-4">{{ item.theoryHours == null ? '—' : `${item.theoryHours} ore` }}</td><td class="px-5 py-4">{{ item.practiceHours == null ? '—' : `${item.practiceHours} ore` }}</td><td class="px-5 py-4">{{ item.durationWeeks == null ? '—' : `${item.durationWeeks} săptămâni` }}</td></tr></tbody></table></div></div>

      <div class="mt-10 grid gap-6 lg:grid-cols-2"><article class="rounded-2xl border border-slate-200 bg-white p-5"><h2 class="text-xl font-semibold">Pregătire</h2><div class="mt-5 flex items-center gap-3"><Users class="size-9 rounded-full bg-purple-50 p-2 text-purple-800" /><div><strong>{{ school.instructorsCount }} instructori activi</strong><p class="text-sm text-slate-500">Pregătire pentru categoriile disponibile</p></div></div></article><article class="rounded-2xl border border-slate-200 bg-white p-5"><h2 class="text-xl font-semibold">Flotă activă</h2><div class="mt-5 flex items-center gap-3"><Car class="size-9 rounded-full bg-purple-50 p-2 text-purple-800" /><div><strong>{{ school.vehiclesCount }} vehicule active</strong><p class="text-sm text-slate-500">Vehicule pentru instruire practică</p></div></div></article></div>

      <div class="mt-6"><SchoolMapPreview :school-id="school.id" :name="school.shortName || school.name" :latitude="school.latitude" :longitude="school.longitude" /></div>

      <div class="mt-10"><h2 class="text-2xl font-semibold">Recenziile absolvenților</h2><div class="mt-5 grid gap-4 lg:grid-cols-2"><article v-for="review in reviews" :key="review.id" class="rounded-2xl border border-slate-200 bg-white p-5"><div class="flex items-center gap-1 text-amber-500"><Star v-for="star in review.ratingOverall" :key="star" class="size-4 fill-current" /></div><h3 class="mt-3 font-semibold">{{ review.title || 'Recenzie absolvent' }}</h3><p class="mt-2 text-sm text-slate-500">{{ review.comment || '—' }}</p><p v-if="review.isVerifiedGraduate" class="mt-4 inline-flex items-center gap-1 text-xs font-semibold text-emerald-600"><CheckCircle2 class="size-3.5" /> Absolvent verificat</p></article><p v-if="!reviews.length" class="rounded-2xl border border-dashed border-slate-300 p-5 text-sm text-slate-500">Încă nu există recenzii publicate.</p></div></div>
    </template>
    <Transition name="toast"><p v-if="toast" class="fixed bottom-6 right-6 z-50 rounded-xl border border-red-200 bg-white px-4 py-3 text-sm font-semibold text-red-700 shadow-lg">{{ toast }}</p></Transition>
  </section>
</template>

<style scoped>
.toast-enter-active,.toast-leave-active{transition:all .2s ease}.toast-enter-from,.toast-leave-to{opacity:0;transform:translateY(8px)}
</style>
