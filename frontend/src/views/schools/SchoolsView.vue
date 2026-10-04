<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { CheckCircle2, ChevronDown, ChevronLeft, ChevronRight, MapPin, Star } from '@lucide/vue'
import { useRoute } from 'vue-router'
import FiltersAside from '@/components/schools/FiltersAside.vue'
import type { SchoolFilters } from '@/components/schools/FiltersAside.vue'
import { getSchools } from '@/api/schools'
import { addSchoolToCompare, comparedSchools } from '@/stores/compare'
import type { SchoolCard } from '@/types/school-card'
import TitleSection from '@/views/schools/sections/TitleSection.vue'

const route = useRoute()
const initialCategory = typeof route.query.category === 'string' ? route.query.category : 'B'
const localityQuery = typeof route.query.localityId === 'string' ? Number(route.query.localityId) : NaN
const initialLocalityId = Number.isFinite(localityQuery) ? localityQuery : undefined
const minimumPracticeQuery = typeof route.query.minimumPracticeRate === 'string'
  ? Number(route.query.minimumPracticeRate)
  : 50
const initialMinimumPracticeRate = Number.isFinite(minimumPracticeQuery) ? minimumPracticeQuery : 50

const filterValues = ref<SchoolFilters>({
  category: initialCategory,
  localityId: initialLocalityId,
  minimumPracticeRate: initialMinimumPracticeRate,
  minimumRating: 4,
  activeOnly: true,
  verifiedOnly: false,
})
const sort = ref<'rank' | 'theory' | 'practice' | 'firstTry' | 'rating' | 'price' | 'candidates'>('practice')
const schools = ref<SchoolCard[]>([])
const loading = ref(false)
const page = ref(1)
const total = ref(0)
const pageSize = 6
const toastMessage = ref('')
let toastTimeout: ReturnType<typeof setTimeout> | undefined

const totalPages = computed(() => Math.max(1, Math.ceil(total.value / pageSize)))
const pageNumbers = computed(() => Array.from({ length: totalPages.value }, (_, index) => index + 1))

async function loadSchools() {
  loading.value = true

  try {
    const response = await getSchools({
      category: filterValues.value.category,
      localityId: filterValues.value.localityId,
      search: filterValues.value.search,
      sort: sort.value,
      limit: 100,
      offset: 0,
    })

    const filteredSchools = response.items.filter((school) => {
      const meetsPracticeRate = school.practicePassRate >= filterValues.value.minimumPracticeRate
      const meetsRating = !filterValues.value.minimumRating || school.rating >= filterValues.value.minimumRating
      const meetsVerified = !filterValues.value.verifiedOnly || school.verified

      return meetsPracticeRate && meetsRating && meetsVerified
    })

    total.value = filteredSchools.length
    schools.value = filteredSchools.slice((page.value - 1) * pageSize, page.value * pageSize)
  } finally {
    loading.value = false
  }
}

function updateFilters(filters: SchoolFilters) {
  filterValues.value = filters
  page.value = 1
  void loadSchools()
}

function goToPage(nextPage: number) {
  page.value = Math.min(Math.max(nextPage, 1), totalPages.value)
  void loadSchools()
}

function addToCompare(school: SchoolCard) {
  const result = addSchoolToCompare(school)

  if (result === 'full') {
    toastMessage.value = 'Poți compara maximum 3 școli. Elimină una pentru a adăuga alta.'
    if (toastTimeout) clearTimeout(toastTimeout)
    toastTimeout = setTimeout(() => { toastMessage.value = '' }, 3500)
  }
}

function formatPercent(value: number) {
  return `${Math.round(value)}%`
}

onMounted(loadSchools)
watch(sort, () => {
  page.value = 1
  void loadSchools()
})
</script>

<template>
  <div class="py-8 md:py-12">
    <TitleSection />

    <div class="mt-8 grid grid-cols-1 gap-6 lg:grid-cols-[290px_minmax(0,1fr)]">
      <FiltersAside :initial-category="initialCategory" :initial-locality-id="initialLocalityId" :initial-minimum-practice-rate="initialMinimumPracticeRate" @change="updateFilters" />

      <div class="min-w-0">
        <div class="mb-5 flex items-center justify-between gap-4">
          <p class="text-sm text-slate-500">
            {{ loading ? 'Se încarcă școlile…' : `${total} școli găsite` }}
          </p>

          <label class="relative flex items-center   shrink-0 text-sm text-slate-500 bg-white rounded-md p-2">
            <span class="mr-1">Sortare:</span>
            <select v-model="sort" class="cursor-pointer appearance-none bg-transparent pr-5 font-semibold text-slate-600 outline-none">
              <option value="practice">Promovare practică</option>
              <option value="theory">Promovare teorie</option>
              <option value="firstTry">Prima încercare</option>
              <option value="rating">Rating</option>
              <option value="price">Preț</option>
              <option value="rank">Clasament</option>
            </select>
            <ChevronDown class="pointer-events-none absolute right-1.5 top-1/2 size-4 -translate-y-1/2" />
          </label>
        </div>

        <div class="space-y-4">
          <article v-for="school in schools" :key="school.id" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-xs">
            <div class="grid gap-6 md:grid-cols-[minmax(0,1.1fr)_minmax(245px,1fr)_145px]">
              <div class="min-w-0">
                <div class="flex flex-wrap items-center gap-x-2 gap-y-1">
                  <h2 class="text-lg font-medium text-slate-800">{{ school.name }}</h2>
                  <span v-if="school.verified" class="inline-flex items-center gap-1 text-xs font-medium text-emerald-600">
                    <CheckCircle2 class="size-3.5" /> Date verificate
                  </span>
                </div>

                <p class="mt-3 flex items-center gap-2 text-sm text-slate-500">
                  <MapPin class="size-4 shrink-0" />
                  <span>{{ school.city }}, {{ school.address }}</span>
                </p>

                <div class="mt-4 flex flex-wrap gap-2">
                  <span v-for="item in school.categories" :key="item" class="rounded-md bg-purple-50 px-2.5 py-1 text-xs font-bold text-purple-800">{{ item }}</span>
                  <span v-if="school.hasOwnTrainingGround" class="rounded-md bg-slate-100 px-2.5 py-1 text-xs font-semibold text-slate-500">Poligon propriu</span>
                </div>
              </div>

              <div class="space-y-4">
                <div v-for="stat in [
                  { label: 'Teorie', value: school.theoryPassRate, color: 'bg-purple-500' },
                  { label: 'Practică', value: school.practicePassRate, color: 'bg-emerald-600' },
                  { label: 'Prima încercare', value: school.firstTryPassRate, color: 'bg-violet-500' },
                ]" :key="stat.label">
                  <div class="mb-1 flex justify-between text-xs"><span class="text-slate-500">{{ stat.label }}</span><strong class="text-slate-800">{{ formatPercent(stat.value) }}</strong></div>
                  <div class="h-1.5 overflow-hidden rounded-full bg-slate-100"><div class="h-full rounded-full" :class="stat.color" :style="{ width: `${stat.value}%` }" /></div>
                </div>
              </div>

              <div class="grid grid-cols-2 gap-x-4 gap-y-3 md:block">
                <div><strong class="text-xl text-slate-800">#{{ school.rank }}</strong><p class="mt-0.5 text-xs text-slate-500">în clasament</p></div>
                <div class="mt-0 md:mt-3"><p class="flex items-center gap-1 text-sm font-bold text-slate-800"><Star class="size-3.5 fill-amber-400 text-amber-400" /> {{ school.rating }}</p><p class="mt-0.5 text-xs text-slate-500">{{ school.reviewsCount }} recenzii</p></div>
                <div class="mt-0 md:mt-3"><strong class="text-sm text-slate-800">{{ school.candidatesCount }}</strong><p class="mt-0.5 text-xs text-slate-500">candidați</p></div>
                <div class="col-span-2 mt-0 md:mt-3"><p class="text-xs text-slate-500">de la</p><strong class="text-base text-slate-800">{{ school.priceFrom.toLocaleString('ro-MD') }} MDL</strong></div>
              </div>
            </div>

            <div class="mt-5 flex flex-wrap gap-2 border-t border-slate-100 pt-4 md:justify-end">
              <RouterLink :to="`/schools/${school.id}`" class="inline-flex h-10 items-center justify-center rounded-lg bg-purple-800 px-4 text-sm font-semibold !text-white hover:bg-purple-900 transition-all duration-200">Vezi profilul</RouterLink>
              <button type="button" class="inline-flex h-10 items-center justify-center rounded-lg border border-slate-700 px-4 text-sm font-semibold text-slate-700 transition-all duration-200 hover:bg-slate-50" @click="addToCompare(school)">
                {{ comparedSchools.some((item) => item.id === school.id) ? 'Adăugată' : '+ Compară' }}
              </button>
            </div>
          </article>

          <p v-if="!loading && !schools.length" class="rounded-2xl border border-dashed border-slate-200 bg-white p-8 text-center text-sm text-slate-500">
            Nu am găsit școli pentru filtrele selectate.
          </p>
        </div>

        <nav v-if="totalPages > 1" class="mt-6 flex flex-wrap items-center justify-center gap-2" aria-label="Paginare rezultate">
          <button type="button" class="inline-flex size-9 items-center justify-center rounded-lg border border-slate-200 text-slate-600 transition-colors hover:bg-white disabled:cursor-not-allowed disabled:opacity-40" :disabled="page === 1 || loading" aria-label="Pagina anterioară" @click="goToPage(page - 1)">
            <ChevronLeft class="size-4" />
          </button>

          <button v-for="number in pageNumbers" :key="number" type="button" class="inline-flex size-9 items-center justify-center rounded-lg text-sm font-semibold transition-colors" :class="number === page ? 'bg-purple-500 text-white' : 'border border-slate-200 text-slate-600 hover:bg-white'" :disabled="loading" @click="goToPage(number)">
            {{ number }}
          </button>

          <button type="button" class="inline-flex size-9 items-center justify-center rounded-lg border border-slate-200 text-slate-600 transition-colors hover:bg-white disabled:cursor-not-allowed disabled:opacity-40" :disabled="page === totalPages || loading" aria-label="Pagina următoare" @click="goToPage(page + 1)">
            <ChevronRight class="size-4" />
          </button>
        </nav>
      </div>
    </div>

    <Transition name="toast">
      <div v-if="toastMessage" class="fixed bottom-6 right-6 z-50 max-w-sm rounded-xl border border-red-200 bg-white px-4 py-3 text-sm font-medium text-red-700 shadow-lg" role="alert">
        {{ toastMessage }}
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.toast-enter-active,
.toast-leave-active {
  transition: opacity 180ms ease, transform 180ms ease;
}

.toast-enter-from,
.toast-leave-to {
  opacity: 0;
  transform: translateY(8px);
}
</style>
