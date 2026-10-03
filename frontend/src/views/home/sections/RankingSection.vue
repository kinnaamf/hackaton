<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { ChevronDown, LucideCircleCheck, LucideMapPin } from '@lucide/vue'
import BaseSection from '@/components/ui/BaseSection.vue'
import { getFilters } from '@/api/dictionaries'
import { getSchools } from '@/api/schools'
import type { Filters } from '@/types/api'
import type { SchoolCard } from '@/types/school-card'
import type { Tab } from '@/types/tab'

const filters = ref<Filters | null>(null)
const selectedCategory = ref('B')
const selectedYear = ref<number | null>(null)
const schools = ref<SchoolCard[]>([])
const loading = ref(false)

const tabs: Tab[] = [
  { label: 'Teorie', value: 'theory' },
  { label: 'Practica', value: 'practice' },
  { label: 'Prima incercare', value: 'firstTry' },
]

const activeTab = ref<Tab>(tabs[0]!)

const sort = computed(() => activeTab.value.value)

async function loadSchools() {
  loading.value = true

  try {
    const response = await getSchools({
      category: selectedCategory.value,
      year: selectedYear.value ?? undefined,
      sort: sort.value,
      limit: 6,
    })

    schools.value = response.items
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  filters.value = await getFilters()

  selectedCategory.value = filters.value.categories.includes('B')
      ? 'B'
      : filters.value.categories[0] ?? ''

  selectedYear.value = filters.value.years[0] ?? null

  await loadSchools()
})

watch(
    [selectedCategory, selectedYear, () => activeTab.value.value],
    loadSchools,
)
</script>

<template>
  <BaseSection
      badge="Date comparabile"
      title="Școli cu rezultate bune"
      paragraph="Compară rezultatele pentru categoria selectată."
  >
    <template #actions>
      <div class="flex w-full flex-col gap-2 sm:flex-row sm:items-center">
        <div class="flex bg-white p-2 rounded-md gap-2">
          <button
              v-for="category in filters?.categories ?? []"
              :key="category"
              @click="selectedCategory = category"
              :class="selectedCategory === category ? 'bg-purple-800 text-white rounded-md' : 'hover:bg-purple-100'"
              class="w-8 h-8 rounded-md transition-all duration-200 !font-semibold"
          >
            {{ category }}
          </button>
        </div>

        <div class="relative bg-white h-12 rounded-md sm:w-32">
          <select
              v-model="selectedYear"
              class="w-full h-full px-4 pr-10 appearance-none cursor-pointer outline-none bg-transparent"
          >
            <option
                v-for="year in filters?.years ?? []"
                :key="year"
                :value="year"
            >
              {{ year }}
            </option>
          </select>

          <ChevronDown
              class="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 pointer-events-none"
          />
        </div>
      </div>
    </template>

    <div class="border-b border-slate-200">
      <div class="flex gap-7">
        <button
            v-for="tab in tabs"
            :key="tab.value"
            type="button"
            class="relative pb-3 text-sm font-semibold transition-colors duration-200 cursor-pointer"
            :class="
          activeTab === tab
            ? 'text-indigo-600'
            : 'text-slate-500 hover:text-slate-800'
        "
            @click="activeTab = tab"
        >
          {{ tab.label }}

          <span
              v-if="activeTab === tab"
              class="absolute -bottom-px left-0 h-0.5 w-full bg-indigo-600"
          />
        </button>
      </div>
    </div>

    <!-- Cards section -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 mt-8 gap-4">
      <div v-for="school in schools" class="bg-white rounded-2xl p-4 shadow-xs">
        <!-- Card header -->
        <div class="flex gap-2 items-center">
          <span class="text-[17px] font-medium">{{ school.name }}</span>
          <span class="flex items-center gap-1 text-emerald-500 text-xs font-bold h-4 shrink-0">
            <LucideCircleCheck class="text-emerald-500 h-3 w-3" :stroke-width="3"/>
            Date verificate
          </span>
        </div>

        <!-- Address -->
        <div class="flex gap-2 items-center mt-3">
          <LucideMapPin class="w-4 h-4 stroke-gray-400"/>
          <span class="text-gray-400 text-sm">{{ school.city }}, {{ school.address }}</span>
        </div>

        <!-- Categories -->
        <div class="flex gap-2 items-center mt-4">
          <div v-for="category in school.categories"
               class="px-2 py-1 text-xs font-bold bg-purple-200 flex items-center justify-center rounded-sm text-purple-800">
            {{ category }}
          </div>
          <span
              class="px-2 py-1 text-xs font-semibold text-zinc-500 bg-gray-200 rounded-sm"
              v-if="school.hasOwnTrainingGround">Poligon propriu</span>
        </div>

        <!-- Statistics block -->
        <div class="mt-4">
          <div class="space-y-4">
            <!-- Teorie -->
            <div>
              <div class="mb-1.5 flex items-center justify-between">
                <span class="text-xs text-slate-500">
                  Teorie
                </span>

                <span class="text-xs font-bold text-slate-800">
                  {{ school.theoryPassRate }}%
                </span>
              </div>

              <div class="h-1 w-full overflow-hidden rounded-full bg-slate-200">
                <div
                    class="h-full rounded-full bg-[#536fe8]"
                    :style="{ width: `${school.theoryPassRate}%` }"
                />
              </div>
            </div>

            <!-- Practică -->
            <div>
              <div class="mb-1.5 flex items-center justify-between">
                <span class="text-xs text-slate-500">
                  Practică
                </span>

                <span class="text-xs font-bold text-slate-800">
                  {{ school.practicePassRate }}%
                </span>
              </div>

              <div class="h-1 w-full overflow-hidden rounded-full bg-slate-200">
                <div
                    class="h-full rounded-full bg-emerald-600"
                    :style="{ width: `${school.practicePassRate}%` }"
                />
              </div>
            </div>

            <!-- Prima încercare -->
            <div>
              <div class="mb-1.5 flex items-center justify-between">
                <span class="text-xs text-slate-500">
                  Prima încercare
                </span>

                <span class="text-xs font-bold text-slate-800">
                  {{ school.firstTryPassRate }}%
                </span>
              </div>

              <div class="h-1 w-full overflow-hidden rounded-full bg-slate-200">
                <div
                    class="h-full rounded-full bg-violet-500"
                    :style="{ width: `${school.firstTryPassRate}%` }"
                />
              </div>
            </div>
          </div>
        </div>

        <div class="border-t border-slate-200 pt-4">
          <div class="grid grid-cols-2 gap-4">
            <!-- Ranking -->
            <div>
              <div class="text-xl font-bold text-slate-900">
                #{{ school.rank }}
              </div>
              <div class="mt-1 text-xs text-slate-500">
                în clasament
              </div>
            </div>

            <!-- Rating -->
            <div class="flex flex-col gap-2">
              <div class="flex items-center gap-1">
                <div class="flex items-center gap-1">
                  <span class="text-amber-500">★</span>
                </div>

                <div class="text-sm font-bold text-slate-900">
                  {{ school.rating }}
                </div></div>

              <div class="text-xs text-slate-500">
                {{ school.reviewsCount }} recenzii
              </div>
            </div>

            <!-- Candidates -->
            <div>
              <div class="text-base font-bold text-slate-900">
                {{ school.candidatesCount }}
              </div>

              <div class="text-xs text-slate-500">
                candidați
              </div>
            </div>
          </div>

          <!-- Price -->
          <div class="mt-4">
            <div class="text-xs text-slate-500">
              de la
            </div>

            <div class="mt-1 text-base font-bold text-slate-900">
              {{ school.priceFrom.toLocaleString('ro-MD') }} MDL
            </div>
          </div>

          <!-- Profile -->
          <RouterLink
              :to="`/schools/${school.id}`"
              class="mt-4 inline-flex h-10 items-center justify-center
           rounded-lg bg-purple-800 px-4
           text-sm font-semibold !text-white
           transition-colors hover:bg-purple-900"
          >
            Vezi profilul
          </RouterLink>
        </div>
      </div>
    </div>
  </BaseSection>
</template>
