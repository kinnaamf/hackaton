<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { ChevronDown, RotateCcw, Search } from '@lucide/vue'
import { getFilters } from '@/api/dictionaries'
import type { Filters } from '@/types/api'

export interface SchoolFilters {
  search?: string
  localityId?: number
  category?: string
  minimumPracticeRate: number
  minimumRating?: 3 | 4
  activeOnly: boolean
  verifiedOnly: boolean
}

const props = withDefaults(defineProps<{
  initialCategory?: string
  initialLocalityId?: number
  initialMinimumPracticeRate?: number
}>(), {
  initialCategory: 'B',
  initialLocalityId: undefined,
  initialMinimumPracticeRate: 50,
})

const emit = defineEmits<{ change: [filters: SchoolFilters] }>()
const availableFilters = ref<Filters | null>(null)
const search = ref('')
const localityId = ref<number | ''>(props.initialLocalityId ?? '')
const category = ref(props.initialCategory)
const minimumPracticeRate = ref(props.initialMinimumPracticeRate)
const minimumRating = ref<3 | 4 | null>(4)
const activeOnly = ref(true)
const verifiedOnly = ref(false)

const currentFilters = computed<SchoolFilters>(() => ({
  search: search.value.trim() || undefined,
  localityId: localityId.value || undefined,
  category: category.value || undefined,
  minimumPracticeRate: minimumPracticeRate.value,
  minimumRating: minimumRating.value ?? undefined,
  activeOnly: activeOnly.value,
  verifiedOnly: verifiedOnly.value,
}))

function resetFilters() {
  search.value = ''
  localityId.value = ''
  category.value = 'B'
  minimumPracticeRate.value = props.initialMinimumPracticeRate
  minimumRating.value = 4
  activeOnly.value = true
  verifiedOnly.value = false
}

onMounted(async () => {
  availableFilters.value = await getFilters()
  if (!availableFilters.value.categories.includes(category.value)) {
    category.value = availableFilters.value.categories[0] ?? ''
  }
})

watch(currentFilters, (filters) => emit('change', filters), { deep: true })
</script>

<template>
  <aside class="h-max rounded-2xl border border-slate-200 bg-white p-5 shadow-xs sm:p-6 lg:sticky lg:top-6">
    <h2 class="text-base font-medium text-slate-800">Filtrează rezultatele</h2>

    <div class="mt-5 border-t border-slate-200 pt-5">
      <label class="relative block">
        <Search class="pointer-events-none absolute left-3 top-1/2 size-4 -translate-y-1/2 text-slate-400" />
        <input v-model="search" type="search" placeholder="Caută după denumire" class="h-10 w-full rounded-lg border border-slate-200 bg-white pl-9 pr-3 text-sm text-slate-800 outline-none placeholder:text-slate-400 focus:border-indigo-500">
      </label>
    </div>

    <div class="mt-5">
      <label class="block text-sm font-semibold text-slate-800" for="school-locality">Localitate</label>
      <div class="relative mt-2">
        <select id="school-locality" v-model="localityId" class="h-10 w-full cursor-pointer appearance-none rounded-lg border border-slate-200 bg-white px-3 pr-9 text-sm text-slate-800 outline-none focus:border-indigo-500">
          <option value="">Toate localitățile</option>
          <option v-for="locality in availableFilters?.localities ?? []" :key="locality.id" :value="locality.id">{{ locality.name }} ({{ locality.schoolsCount }})</option>
        </select>
        <ChevronDown class="pointer-events-none absolute right-3 top-1/2 size-4 -translate-y-1/2 text-slate-500" />
      </div>
    </div>

    <div class="mt-5 border-t border-slate-200 pt-5">
      <p class="text-sm font-semibold text-slate-800">Categoria permisului</p>
      <div class="mt-3 flex flex-wrap gap-2">
        <button v-for="item in availableFilters?.categories ?? []" :key="item" type="button" class="min-w-8 rounded-md px-2 py-1.5 text-xs font-bold transition-colors" :class="category === item ? 'bg-purple-800 text-white' : 'bg-slate-100 text-slate-500 hover:bg-purple-50 hover:text-purple-600'" @click="category = item">{{ item }}</button>
      </div>
    </div>

    <div class="mt-5 border-t border-slate-200 pt-5">
      <div class="flex items-center justify-between gap-3">
        <label class="text-sm font-semibold text-slate-800" for="practice-rate">Promovare practică</label>
        <span class="text-xs font-medium text-purple-800">{{ minimumPracticeRate }}%+</span>
      </div>
      <input id="practice-rate" v-model.number="minimumPracticeRate" type="range" min="0" max="100" step="5" class="mt-3 h-1.5 w-full cursor-pointer accent-indigo-500">
      <div class="mt-2 flex justify-between text-xs text-slate-400"><span>0%</span><span>100%</span></div>
    </div>

    <fieldset class="mt-5 border-t border-slate-200 pt-5">
      <legend class="text-sm font-semibold text-slate-800">Rating</legend>
      <label class="mt-3 flex cursor-pointer items-center gap-2 text-sm text-slate-500"><input v-model="minimumRating" :value="4" type="radio" class="size-4 accent-indigo-500">4+ stele</label>
      <label class="mt-2 flex cursor-pointer items-center gap-2 text-sm text-slate-500"><input v-model="minimumRating" :value="3" type="radio" class="size-4 accent-indigo-500">3+ stele</label>
    </fieldset>

    <div class="mt-5 border-t border-slate-200 pt-5">
      <label class="flex cursor-pointer items-center gap-2 text-sm text-slate-500"><input v-model="activeOnly" type="checkbox" class="size-4 rounded accent-indigo-500">Doar școli active</label>
      <label class="mt-3 flex cursor-pointer items-center gap-2 text-sm text-slate-500"><input v-model="verifiedOnly" type="checkbox" class="size-4 rounded accent-indigo-500">Date verificate</label>
    </div>

    <button type="button" class="mt-5 inline-flex items-center gap-2 text-sm font-semibold text-purple-800 hover:text-purple-900" @click="resetFilters">
      <RotateCcw class="size-4" />
      Resetează filtrele
    </button>
  </aside>
</template>
