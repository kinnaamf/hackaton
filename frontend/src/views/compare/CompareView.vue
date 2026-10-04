<script setup lang="ts">
import { computed } from 'vue'
import { CheckCircle2, Plus, X } from '@lucide/vue'
import { comparedSchools, removeSchoolFromCompare } from '@/stores/compare'

const rows = computed(() => [
  { label: 'Localitate', value: (school: typeof comparedSchools.value[number]) => school.city || '—' },
  { label: 'Date verificate', value: (school: typeof comparedSchools.value[number]) => school.verified ? 'Da' : 'Nu' },
  { label: 'Poziție clasament', value: (school: typeof comparedSchools.value[number]) => school.rank ? `#${school.rank}` : '—' },
  { label: 'Candidați', value: (school: typeof comparedSchools.value[number]) => school.candidatesCount.toLocaleString('ro-MD') },
  { label: 'Promovare teorie', highlight: true, value: (school: typeof comparedSchools.value[number]) => school.theoryPassRate != null ? `${Math.round(school.theoryPassRate)}%` : '—' },
  { label: 'Promovare practică', highlight: true, value: (school: typeof comparedSchools.value[number]) => school.practicePassRate != null ? `${Math.round(school.practicePassRate)}%` : '—' },
  { label: 'Practică din prima încercare', value: (school: typeof comparedSchools.value[number]) => school.firstTryPassRate != null ? `${Math.round(school.firstTryPassRate)}%` : '—' },
  { label: 'Rating', value: (school: typeof comparedSchools.value[number]) => school.rating != null ? `${school.rating} / 5` : '—' },
  { label: 'Recenzii', value: (school: typeof comparedSchools.value[number]) => school.reviewsCount.toLocaleString('ro-MD') },
  { label: 'Preț de la', value: (school: typeof comparedSchools.value[number]) => school.priceFrom != null ? `${school.priceFrom.toLocaleString('ro-MD')} MDL` : '—' },
])
</script>

<template>
  <section class="py-8 md:py-12">
    <div class="flex flex-col gap-5 md:flex-row md:items-end md:justify-between">
      <div>
        <p class="text-xs font-semibold uppercase tracking-wider text-purple-800">Analiză comparativă</p>
        <h1 class="mt-2 text-3xl font-semibold text-slate-900">Compară școlile auto</h1>
        <p class="mt-2 text-slate-500">Selectează până la trei școli și analizează indicatorii în același context.</p>
      </div>
      <RouterLink to="/schools" class="inline-flex h-11 items-center justify-center gap-2 rounded-lg bg-purple-800 px-4 text-sm font-semibold !text-white transition-all duration-200 hover:bg-purple-900">
        <Plus class="size-4" /> Adaugă școli
      </RouterLink>
    </div>

    <div v-if="!comparedSchools.length" class="mt-8 rounded-2xl border border-dashed border-slate-300 bg-white p-10 text-center">
      <h2 class="text-lg font-semibold text-slate-800">Nu ai adăugat încă școli</h2>
      <p class="mt-2 text-sm text-slate-500">Din pagina «Școli auto», apasă «+ Compară» pe școlile pe care vrei să le analizezi.</p>
      <RouterLink to="/schools" class="mt-5 inline-flex h-10 items-center justify-center rounded-lg bg-purple-800 px-4 text-sm font-semibold !text-white transition-all duration-200 hover:bg-purple-900">Vezi școlile</RouterLink>
    </div>

    <div v-else class="mt-8 overflow-x-auto rounded-2xl border border-slate-200 bg-white">
      <table class="w-full min-w-[760px] border-collapse text-left text-sm">
        <thead class="bg-slate-50">
          <tr>
            <th class="w-52 border-b border-slate-200 px-5 py-5 font-semibold text-slate-500">Indicator</th>
            <th v-for="school in comparedSchools" :key="school.id" class="min-w-60 border-b border-l border-slate-200 px-5 py-5 align-top">
              <div class="flex items-start justify-between gap-3">
                <div>
                  <div class="flex items-center gap-1.5 font-semibold text-slate-800">
                    {{ school.name }}
                    <CheckCircle2 v-if="school.verified" class="size-4 text-emerald-600" />
                  </div>
                  <p class="mt-1 text-xs font-normal text-slate-500">{{ school.city }}</p>
                  <RouterLink :to="`/schools/${school.id}`" class="mt-3 inline-block text-xs font-semibold text-purple-800 hover:text-purple-900">Vezi profilul →</RouterLink>
                </div>
                <button type="button" class="rounded-md p-1 text-slate-400 hover:bg-slate-100 hover:text-slate-700" :aria-label="`Elimină ${school.name}`" @click="removeSchoolFromCompare(school.id)"><X class="size-4" /></button>
              </div>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="row in rows" :key="row.label" class="border-b border-slate-100 last:border-0">
            <th class="bg-slate-50/60 px-5 py-4 font-medium text-slate-500">{{ row.label }}</th>
            <td v-for="school in comparedSchools" :key="school.id" class="border-l border-slate-100 px-5 py-4" :class="row.highlight ? 'font-bold text-purple-800' : 'text-slate-700'">{{ row.value(school) }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>
</template>
