<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import { MapPin } from '@lucide/vue'

const props = defineProps<{
  schoolId: number
  name: string
  latitude: number | null
  longitude: number | null
}>()

const element = ref<HTMLElement | null>(null)
let map: L.Map | null = null

onMounted(() => {
  if (!element.value || props.latitude == null || props.longitude == null) return

  map = L.map(element.value, { zoomControl: false, dragging: false, scrollWheelZoom: false, doubleClickZoom: false, attributionControl: false })
    .setView([props.latitude, props.longitude], 15)
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map)
  L.circleMarker([props.latitude, props.longitude], { radius: 10, color: '#fff', weight: 3, fillColor: '#6b21a8', fillOpacity: 1 }).addTo(map)
})

onBeforeUnmount(() => map?.remove())
</script>

<template>
  <article class="overflow-hidden rounded-2xl border border-slate-200 bg-white">
    <div class="flex items-center justify-between gap-4 p-5"><div><p class="text-xs font-semibold uppercase tracking-wider text-purple-800">Localizare</p><h2 class="mt-1 text-xl font-semibold">Școala pe hartă</h2></div><MapPin class="size-5 text-purple-800" /></div>
    <div v-if="latitude != null && longitude != null" ref="element" class="h-56 w-full" />
    <p v-else class="px-5 py-10 text-center text-sm text-slate-500">Coordonatele școlii nu sunt disponibile.</p>
    <RouterLink :to="{ path: '/map', query: { school: String(schoolId) } }" class="flex items-center justify-center gap-2 border-t border-slate-200 px-5 py-3 text-sm font-semibold text-purple-800 transition-colors hover:bg-purple-50">Vezi pe hartă <span aria-hidden="true">→</span></RouterLink>
  </article>
</template>
