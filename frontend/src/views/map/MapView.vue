<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import { CheckCircle2, ChevronDown, MapPin, Search } from '@lucide/vue'
import { getFilters } from '@/api/dictionaries'
import { getSchoolLocation, getSchools, type SchoolLocation } from '@/api/schools'
import type { Filters } from '@/types/api'

const mapElement = ref<HTMLElement | null>(null)
const map = ref<any>(null)
let markers: any = null

const apiFilters = ref<Filters | null>(null)
const search = ref('')
const localityId = ref<number | ''>('')
const category = ref('B')
const schools = ref<SchoolLocation[]>([])
const selectedId = ref<number | null>(null)
const loading = ref(false)

const selectedSchool = computed(() => schools.value.find((school) => school.id === selectedId.value) ?? null)

function initMap() {
  if (!mapElement.value || map.value) return

  map.value = L.map(mapElement.value, { zoomControl: true }).setView([47.0105, 28.8638], 7)
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; OpenStreetMap contributors',
  }).addTo(map.value)
  markers = L.layerGroup().addTo(map.value)
}

function renderMarkers() {
  if (!map.value || !markers) return
  markers.clearLayers()

  const points = schools.value.filter((school) => school.latitude != null && school.longitude != null)
  points.forEach((school) => {
    const active = school.id === selectedId.value
    const marker = L.circleMarker([school.latitude!, school.longitude!], {
      radius: active ? 11 : 9,
      color: '#ffffff',
      weight: 3,
      fillColor: '#6b21a8',
      fillOpacity: 1,
    }).bindTooltip(school.name, { direction: 'top', offset: [0, -8] })

    marker.on('click', () => selectSchool(school))
    marker.addTo(markers!)
  })

  if (points.length) {
    map.value.fitBounds(L.latLngBounds(points.map((school) => [school.latitude!, school.longitude!])), { padding: [40, 40], maxZoom: 11 })
  }
}

function selectSchool(school: SchoolLocation) {
  selectedId.value = school.id
  if (map.value && school.latitude != null && school.longitude != null) {
    map.value.panTo([school.latitude, school.longitude])
  }
  renderMarkers()
}

async function loadSchools() {
  loading.value = true
  try {
    const response = await getSchools({
      category: category.value,
      localityId: localityId.value || undefined,
      search: search.value.trim() || undefined,
      sort: 'practice',
      limit: 100,
    })
    schools.value = (await Promise.all(response.items.map((school) => getSchoolLocation(school.id))))
    selectedId.value = schools.value[0]?.id ?? null
    await nextTick()
    renderMarkers()
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  initMap()
  apiFilters.value = await getFilters()
  if (!apiFilters.value.categories.includes(category.value)) category.value = apiFilters.value.categories[0] ?? ''
  await loadSchools()
})

onBeforeUnmount(() => map.value?.remove())
</script>

<template>
  <section class="py-8 md:py-12">
    <p class="text-xs font-semibold uppercase tracking-wider text-purple-800">Localizare</p>
    <h1 class="mt-2 text-3xl font-semibold text-slate-900">Școli auto pe hartă</h1>
    <p class="mt-2 text-slate-500">Explorează școlile și filialele din localitatea ta.</p>

    <div class="mt-8 grid overflow-hidden rounded-2xl border border-slate-200 bg-white lg:grid-cols-[320px_minmax(0,1fr)]">
      <aside class="border-b border-slate-200 p-4 lg:border-b-0 lg:border-r">
        <form class="space-y-3" @submit.prevent="loadSchools">
          <label class="relative block"><Search class="pointer-events-none absolute left-3 top-1/2 size-4 -translate-y-1/2 text-slate-400" /><input v-model="search" placeholder="Caută o școală" class="h-10 w-full rounded-lg border border-slate-200 pl-9 pr-3 text-sm outline-none focus:border-purple-800"></label>
          <div class="grid grid-cols-2 gap-2">
            <div class="relative"><select v-model="localityId" class="h-10 w-full appearance-none rounded-lg border border-slate-200 bg-white px-3 pr-7 text-xs font-semibold outline-none"><option value="">Toate localitățile</option><option v-for="locality in apiFilters?.localities ?? []" :key="locality.id" :value="locality.id">{{ locality.name }}</option></select><ChevronDown class="pointer-events-none absolute right-2 top-3 size-4 text-slate-500" /></div>
            <div class="relative"><select v-model="category" class="h-10 w-full appearance-none rounded-lg border border-slate-200 bg-white px-3 pr-7 text-xs font-semibold outline-none"><option v-for="item in apiFilters?.categories ?? []" :key="item" :value="item">Categoria {{ item }}</option></select><ChevronDown class="pointer-events-none absolute right-2 top-3 size-4 text-slate-500" /></div>
          </div>
          <button type="submit" class="h-10 w-full rounded-lg bg-purple-800 text-sm font-semibold text-white transition-all duration-200 hover:bg-purple-900">Aplică filtrele</button>
        </form>

        <p class="mt-5 text-xs text-slate-500">{{ loading ? 'Se încarcă…' : `${schools.length} rezultate` }}</p>
        <div class="mt-2 max-h-[430px] space-y-1 overflow-y-auto pr-1">
          <button v-for="school in schools" :key="school.id" type="button" class="w-full rounded-lg border-l-4 p-3 text-left transition-colors" :class="school.id === selectedId ? 'border-purple-800 bg-purple-50' : 'border-transparent hover:bg-slate-50'" @click="selectSchool(school)">
            <div class="flex items-center gap-1.5 text-sm font-semibold text-slate-800">{{ school.name }}<CheckCircle2 v-if="school.verified" class="size-3.5 text-emerald-600" /></div>
            <p class="mt-1 flex items-center gap-1 text-xs text-slate-500"><MapPin class="size-3.5" />{{ school.city }} · Practică {{ Math.round(school.practicePassRate) }}%</p>
            <p class="mt-1 pl-4 text-xs font-semibold text-slate-600">{{ school.priceFrom?.toLocaleString('ro-MD') ?? '—' }} MDL</p>
          </button>
        </div>
      </aside>

      <div class="relative min-h-[460px]">
        <div ref="mapElement" class="absolute inset-0"></div>
        <div v-if="selectedSchool" class="absolute bottom-4 left-4 z-[500] max-w-xs rounded-xl bg-white p-4 shadow-lg">
          <div class="flex items-start justify-between gap-3"><div><h2 class="font-semibold text-slate-800">{{ selectedSchool.name }}</h2><p class="mt-1 text-xs text-slate-500">Categoria {{ category }} · {{ selectedSchool.city }}</p></div><CheckCircle2 v-if="selectedSchool.verified" class="size-4 text-emerald-600" /></div>
          <div class="mt-4 flex gap-5 text-sm"><span><strong class="text-purple-800">{{ Math.round(selectedSchool.practicePassRate) }}%</strong> practică</span><span><strong>{{ selectedSchool.priceFrom?.toLocaleString('ro-MD') ?? '—' }}</strong> MDL</span></div>
          <RouterLink :to="`/schools/${selectedSchool.id}`" class="mt-4 inline-block text-sm font-semibold text-purple-800 hover:text-purple-900">Vezi profilul →</RouterLink>
        </div>
      </div>
    </div>
  </section>
</template>
