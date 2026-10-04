<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { ChevronDown, LucideCircleCheck, LucideMapPin } from '@lucide/vue'
import BaseSection from '@/components/ui/BaseSection.vue'
import { getFilters } from '@/api/dictionaries'
import { getSchools } from '@/api/schools'
import type { Filters } from '@/types/api'
import type { SchoolCard } from '@/types/school-card'
import type { Tab } from '@/types/tab'
import { schoolProfilePath } from '@/utils/school'

const filters = ref<Filters | null>(null)
const selectedCategory = ref('B')
const selectedYear = ref<number | null>(null)
const schools = ref<SchoolCard[]>([])
const loading = ref(false)
const visibleCount = ref(3)

const tabs: Tab[] = [
  { label: 'Teorie', value: 'theory' },
  { label: 'Practică', value: 'practice' },
  { label: 'Prima încercare', value: 'firstTry' },
]

const activeTab = ref<'theory' | 'practice' | 'firstTry'>('theory')

const sort = computed(() => activeTab.value)

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

function showMore() {
  visibleCount.value += 3
}

function formatPercent(value: number | null | undefined) {
  return Number.isFinite(value) ? `${Math.round(value!)}%` : '—'
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
    [selectedCategory, selectedYear, activeTab],
    () => {
      visibleCount.value = 3
      void loadSchools()
    },
)
</script>

<template>
  <BaseSection
      badge="Date comparabile"
      title="Școli cu rezultate bune"
      paragraph="Compară rezultatele pentru categoria selectată."
  >
    <template #actions>
      <div class="grid w-full grid-cols-1 gap-3 sm:grid-cols-2 md:w-[380px]">
        <label class="block">
          <span class="mb-1.5 block text-xs font-medium text-slate-500">
            După categorie
          </span>

          <div class="relative h-11 rounded-lg border border-slate-200 bg-white transition-colors focus-within:border-indigo-500">
            <select
                v-model="selectedCategory"
                class="h-full w-full cursor-pointer appearance-none rounded-lg bg-transparent px-3 pr-10 text-sm font-semibold text-slate-800 outline-none"
            >
              <option
                  v-for="category in filters?.categories ?? []"
                  :key="category"
                  :value="category"
              >
                Categoria {{ category }}
              </option>
            </select>

            <ChevronDown class="pointer-events-none absolute right-3 top-1/2 size-4 -translate-y-1/2 text-slate-500" />
          </div>
        </label>

        <label class="block">
          <span class="mb-1.5 block text-xs font-medium text-slate-500">
            După an
          </span>

          <div class="relative h-11 rounded-lg border border-slate-200 bg-white transition-colors focus-within:border-indigo-500">
            <select
                v-model="selectedYear"
                class="h-full w-full cursor-pointer appearance-none rounded-lg bg-transparent px-3 pr-10 text-sm font-semibold text-slate-800 outline-none"
            >
              <option
                  v-for="year in filters?.years ?? []"
                  :key="year"
                  :value="year"
              >
                {{ year }}
              </option>
            </select>

            <ChevronDown class="pointer-events-none absolute right-3 top-1/2 size-4 -translate-y-1/2 text-slate-500" />
          </div>
        </label>
      </div>
    </template>

    <div class="border-b border-slate-200">
      <div class="flex flex-wrap gap-1">
        <button
            v-for="tab in tabs"
            :key="tab.value"
            type="button"
            class="relative whitespace-nowrap px-3 py-3 text-sm font-semibold text-zinc-500 transition-colors duration-300 hover:text-purple-800"
            :class="
          activeTab === tab.value
            ? 'text-purple-800'
            : ''
        "
            @click="activeTab = tab.value as 'theory' | 'practice' | 'firstTry'"
        >
          {{ tab.label }}
          <span v-if="activeTab === tab.value" class="absolute -bottom-px left-0 h-0.5 w-full bg-purple-800" />
        </button>
      </div>
    </div>

    <!-- Cards section -->
    <TransitionGroup name="school-card" tag="div" class="mt-8 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
      <div v-for="school in schools.slice(0, visibleCount)" :key="school.id" class="bg-white rounded-2xl p-4 shadow-xs">
        <!-- Card header -->
        <div class="flex gap-2 items-center">
          <RouterLink :to="schoolProfilePath(school)" class="text-[17px] font-medium transition-colors hover:text-purple-800">{{ school.name }}</RouterLink>
          <span class="flex items-center gap-1 text-emerald-500 text-xs font-bold h-4 shrink-0">
            <LucideCircleCheck class="text-emerald-500 h-3 w-3" :stroke-width="3"/>
            Date verificate
          </span>
        </div>

        <!-- Address -->
        <RouterLink :to="{ path: '/map', query: { school: String(school.id) } }" class="flex gap-2 items-center mt-3 transition-colors hover:text-purple-800">
          <LucideMapPin class="w-4 h-4 stroke-gray-400"/>
          <span class="text-gray-400 text-sm">{{ school.city }}, {{ school.address }}</span>
        </RouterLink>

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
                  {{ formatPercent(school.theoryPassRate) }}
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
                  {{ formatPercent(school.practicePassRate) }}
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
                  {{ formatPercent(school.firstTryPassRate) }}
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
              :to="schoolProfilePath(school)"
              class="mt-4 inline-flex h-10 items-center justify-center
           rounded-lg bg-purple-800 px-4
           text-sm font-semibold !text-white
           transition-colors hover:bg-purple-900"
          >
            Vezi profilul
          </RouterLink>
        </div>
      </div>
    </TransitionGroup>

    <div v-if="schools.length" class="mt-8 flex justify-center">
      <button
          v-if="visibleCount < schools.length"
          type="button"
          class="inline-flex h-11 items-center justify-center rounded-lg border border-purple-800 px-5 text-sm font-semibold text-purple-800 transition-all duration-200 hover:bg-purple-50"
          @click="showMore"
      >
        Mai multe
      </button>

      <RouterLink
          v-else
          :to="{
            path: '/schools',
            query: {
              sort: 'practice',
              minimumPracticeRate: 70,
            },
          }"
          class="inline-flex h-11 items-center justify-center rounded-lg bg-purple-800 px-5 text-sm font-semibold !text-white transition-all duration-200 hover:bg-purple-900"
      >
        Arată toate
      </RouterLink>
    </div>
  </BaseSection>
</template>

<style scoped>
.school-card-enter-active {
  transition: opacity 360ms ease, transform 360ms ease;
}

.school-card-enter-from {
  opacity: 0;
  transform: translateY(20px) scale(0.98);
}
</style>
