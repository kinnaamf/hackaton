<template>
  <section class="py-8 md:py-12">
    <!-- MAIN -->
    <div>

      <!-- PAGE HEADER -->
      <div class="page-header">
        <div>
          <p class="eyebrow">DATE AGREGATE</p>

          <h1>
            Statistici privind pregătirea și examinarea auto
          </h1>

          <p class="muted large">
            O imagine de ansamblu asupra rezultatelor școlilor auto din Moldova.
          </p>
        </div>

        <div class="grid w-full grid-cols-1 gap-3 sm:grid-cols-2 md:w-[380px]">
          <label class="block">
            <span class="mb-1.5 block text-xs font-medium text-slate-500">După categorie</span>
            <div class="relative h-11 rounded-lg border border-slate-200 bg-white transition-colors focus-within:border-purple-800">
              <select v-model="selectedCategory" class="h-full w-full cursor-pointer appearance-none rounded-lg bg-transparent px-3 pr-10 text-sm font-semibold text-slate-800 outline-none" aria-label="Selectează categoria">
                <option v-for="category in apiFilters?.categories ?? []" :key="category" :value="category">Categoria {{ category }}</option>
              </select>
              <ChevronDown class="pointer-events-none absolute right-3 top-1/2 size-4 -translate-y-1/2 text-slate-500" />
            </div>
          </label>

          <label class="block">
            <span class="mb-1.5 block text-xs font-medium text-slate-500">După an</span>
            <div class="relative h-11 rounded-lg border border-slate-200 bg-white transition-colors focus-within:border-purple-800">
              <select v-model="selectedYear" class="h-full w-full cursor-pointer appearance-none rounded-lg bg-transparent px-3 pr-10 text-sm font-semibold text-slate-800 outline-none" aria-label="Selectează anul">
                <option v-for="year in apiFilters?.years ?? []" :key="year" :value="year">{{ year }}</option>
              </select>
              <ChevronDown class="pointer-events-none absolute right-3 top-1/2 size-4 -translate-y-1/2 text-slate-500" />
            </div>
          </label>
        </div>
      </div>

      <!-- OVERVIEW -->
      <div class="overview-grid">
        <div
            v-for="[value, label] in overviewStats"
            :key="label"
            class="overview-stat"
        >
          <strong>{{ value }}</strong>
          <span>{{ label }}</span>
          <i>{{ selectedYear ? `Date pentru anul ${selectedYear}` : 'Toți anii disponibili' }}</i>
        </div>
      </div>

      <!-- STATISTICS -->
      <div class="statistics-grid">

        <!-- CHART -->
        <div class="data-card chart-card">
          <div class="section-heading">
            <div>
          <p class="eyebrow">Școala lider · {{ featuredPerformance?.name ?? 'se încarcă' }}</p>
              <h2>Evoluția rezultatelor pentru categoria {{ selectedCategory }}</h2>
            </div>
          </div>

          <svg
              viewBox="0 0 700 240"
              preserveAspectRatio="none"
              class="big-chart"
              role="img"
              aria-label="Graficul promovării teoretice și practice"
          >
            <!-- GRID -->
            <g class="grid-lines">
              <path
                  v-for="y in [30, 75, 120, 165, 210]"
                  :key="y"
                  :d="`M15 ${y}H685`"
              />
            </g>

            <!-- THEORY -->
            <path
                :d="theoryPath"
                fill="none"
                stroke="#5b6fd8"
                stroke-width="3"
            />


            <!-- PRACTICE -->
            <path
                :d="practicePath"
                fill="none"
                stroke="#82b29a"
                stroke-width="3"
            />

            <!-- MONTHS -->
            <g class="axis-labels">
              <text
                  v-for="[x, month] in months"
                  :key="month"
                :x="x"
                y="230"
                text-anchor="middle"
              >
                {{ month }}
              </text>
            </g>
          </svg>

          <div class="chart-legend">
            <span>
              <i class="blue-dot"></i>
              Promovare teorie
            </span>

            <span>
              <i class="green-dot"></i>
              Promovare practică
            </span>
          </div>
        </div>

        <!-- FREQUENT ERRORS -->
        <div class="data-card">
          <p class="eyebrow">Date demonstrative</p>

          <h2>Greșeli frecvente</h2>

          <div
              v-for="[label, count, percent] in frequentErrors"
              :key="label"
              class="error-row"
          >
            <div>
              <span>{{ label }}</span>
              <strong>{{ count }}</strong>
            </div>

            <div class="bar">
              <i :style="{ width: `${percent}%` }"></i>
            </div>
          </div>

          <p class="muted small-copy">
            Date agregate · fără identificarea candidaților
          </p>
        </div>
      </div>

      <!-- SCHOOL RANKING -->
      <section class="section">

        <div class="section-heading">
          <div>
            <p class="eyebrow">
              Ordine neutră în baza de date
            </p>

            <h2>Clasamentul școlilor</h2>
          </div>

          <div class="w-full sm:w-[185px]">
            <label class="block">
              <span class="mb-1.5 block text-xs font-medium text-slate-500">După categorie</span>
              <div class="relative h-11 rounded-lg border border-slate-200 bg-white transition-colors focus-within:border-purple-800">
                <select v-model="selectedCategory" class="h-full w-full cursor-pointer appearance-none rounded-lg bg-transparent px-3 pr-10 text-sm font-semibold text-slate-800 outline-none" aria-label="Selectează categoria pentru clasament">
                  <option v-for="category in apiFilters?.categories ?? []" :key="category" :value="category">Categoria {{ category }}</option>
                </select>
                <ChevronDown class="pointer-events-none absolute right-3 top-1/2 size-4 -translate-y-1/2 text-slate-500" />
              </div>
            </label>
          </div>
        </div>

        <div class="table-wrap">
          <table>
            <thead>
            <tr>
              <th
                  v-for="label in tableHeaders"
                  :key="label"
              >
                {{ label }}
              </th>
            </tr>
            </thead>

            <tbody>
            <tr
                v-for="school in schools"
                :key="school.id"
            >
              <td>
                <strong>#{{ school.rank }}</strong>
              </td>

              <td>
                <a
                    class="table-link"
                    :href="`/schools/${school.id}`"
                >
                  {{ school.name }}
                </a>
              </td>

              <td>{{ school.city }}</td>

              <td>{{ school.candidatesCount }}</td>

              <td>{{ formatPercent(school.theoryPassRate) }}</td>

              <td>{{ formatPercent(school.practicePassRate) }}</td>

              <td>{{ formatPercent(school.firstTryPassRate) }}</td>

              <td>{{ school.rating }}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </section>
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { ChevronDown } from '@lucide/vue'
import { getFilters } from '@/api/dictionaries'
import { getFeatured, getSchools } from '@/api/schools'
import { getOverview } from '@/api/stats'
import type { Filters, Overview, Performance } from '@/types/api'
import type { SchoolCard } from '@/types/school-card'

/* -----------------------------
   Navigation
----------------------------- */

const navigation = [
  ['Școli auto', '/schools'],
  ['Compară', '/compare'],
  ['Hartă', '/map'],
  ['Statistici', '/statistics'],
]

/* -----------------------------
   Mobile menu
----------------------------- */

const menuOpen = ref(false)

/* -----------------------------
   Schools
----------------------------- */

const apiFilters = ref<Filters | null>(null)
const selectedYear = ref<number | null>(null)
const selectedCategory = ref('B')
const overviewData = ref<Overview | null>(null)
const schools = ref<SchoolCard[]>([])
const featuredPerformance = ref<Performance | null>(null)

const overviewStats = computed(() => [
  [overviewData.value?.schoolsCount?.toLocaleString('ro-MD') ?? '—', 'Școli auto'],
  [overviewData.value?.localitiesCount?.toLocaleString('ro-MD') ?? '—', 'Localități acoperite'],
  [overviewData.value?.candidatesCount?.toLocaleString('ro-MD') ?? '—', 'Candidați analizați'],
  [formatPercent(overviewData.value?.theoryPassRate), 'Promovare teorie'],
  [formatPercent(overviewData.value?.practicePassRate), 'Promovare practică'],
])

function formatPercent(value: number | null | undefined) {
  return value == null ? '—' : `${Math.round(value)}%`
}

const monthlyPoints = computed(() => featuredPerformance.value?.performance ?? [])
const months = computed(() => monthlyPoints.value.map((point, index) => [
  28 + index * (644 / Math.max(monthlyPoints.value.length - 1, 1)),
  ['Ian', 'Feb', 'Mar', 'Apr', 'Mai', 'Iun', 'Iul', 'Aug', 'Sep', 'Oct', 'Noi', 'Dec'][point.month - 1],
] as const))

function chartPath(metric: 'theory' | 'practice') {
  const points = monthlyPoints.value
  if (!points.length) return ''

  return points.map((point, index) => {
    const x = 15 + index * (670 / Math.max(points.length - 1, 1))
    const y = 210 - (point[metric] ?? 0) * 1.8
    return `${index === 0 ? 'M' : 'L'}${x.toFixed(1)} ${y.toFixed(1)}`
  }).join(' ')
}

const theoryPath = computed(() => chartPath('theory'))
const practicePath = computed(() => chartPath('practice'))

async function loadStatistics() {
  const [overview, ranking, featured] = await Promise.all([
    getOverview(selectedYear.value ?? undefined),
    getSchools({ category: selectedCategory.value, year: selectedYear.value ?? undefined, sort: 'rank', limit: 20 }),
    getFeatured(selectedCategory.value, selectedYear.value ?? undefined),
  ])

  overviewData.value = overview
  schools.value = ranking.items
  featuredPerformance.value = featured
}

onMounted(async () => {
  apiFilters.value = await getFilters()
  selectedYear.value = apiFilters.value.years[0] ?? null
  selectedCategory.value = apiFilters.value.categories.includes('B') ? 'B' : apiFilters.value.categories[0] ?? ''
  await loadStatistics()
})

watch([selectedYear, selectedCategory], () => void loadStatistics())

/* -----------------------------
   Overview statistics
----------------------------- */


/* -----------------------------
   Frequent errors
----------------------------- */

const frequentErrors = [
  ['Neacordarea priorității', 1284, 34],
  ['Parcare necorespunzătoare', 967, 26],
  ['Depășirea vitezei', 742, 20],
  ['Semnalizare incorectă', 538, 14],
]

/* -----------------------------
   Table
----------------------------- */

const tableHeaders = [
  'Poziție',
  'Școală',
  'Localitate',
  'Candidați',
  'Teorie',
  'Practică',
  'Prima încercare',
  'Rating',
]
</script>
