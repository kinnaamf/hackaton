<script setup lang="ts">
import {ref, onMounted} from 'vue'
import {MapPin, GraduationCap, Search, ArrowLeft } from '@lucide/vue'
import PerformanceCard from "@/components/home/PerformanceCard.vue";
import { getFilters } from "@/api/dictionaries.ts";
import type { Filters } from "@/types/api"

const filters = ref<Filters | null>(null)

const localityId = ref<number | null>(null)
const category = ref('B')

onMounted(async () => {
  filters.value = await getFilters()

  const chisinau = filters.value.localities.find(
      (locality) => locality.name === 'Chișinău',
  )

  localityId.value = chisinau?.id ?? filters.value.localities[0]?.id ?? null

  if (!filters.value.categories.includes(category.value)) {
    category.value = filters.value.categories[0] ?? ''
  }
})
</script>

<template>
  <section class="flex flex-col items-center gap-8 pt-8 md:flex-row md:pt-12 lg:gap-16 xl:justify-between">
    <div class="w-full md:max-w-[620px]">
      <div>
        <!-- Hero Text -->
        <h1>
          Alege școala auto după <br>
          <span class="text-purple-800 font-semibold">rezultate reale</span>
        </h1>
        <p class="text-sm text-gray-600 max-w-[560px]">
          Compară școlile auto din Moldova după promovarea examenelor, rezultatele din prima încercare, prețuri,
          recenzii și alți indicatori.
        </p>
      </div>

      <!-- Search box -->
      <div class="bg-white rounded-2xl mt-8 overflow-hidden shadow-xs w-full max-w-[420px]">

        <!-- Localitate -->
        <div class="px-4 py-3 flex gap-3">
          <MapPin class="w-5 h-5 text-blue-600 shrink-0"/>

          <div class="flex-1 min-w-0">
            <label
                for="location"
                class="block text-xs text-zinc-500"
            >
              Localitate
            </label>

            <select
                id="location"
                v-model="localityId"
                class="block w-full bg-transparent font-semibold text-zinc-800 outline-none cursor-pointer"
            >
              <option
                  v-for="locality in filters?.localities ?? []"
                  :key="locality.id"
                  :value="locality.id"
              >
                {{ locality.name }}
              </option>
            </select>
          </div>
        </div>

        <div class="w-full h-px bg-gray-200"/>

        <!-- Categoria permisului -->
        <div class="px-4 py-3 flex gap-3">
          <GraduationCap class="w-5 h-5 text-blue-600 shrink-0"/>

          <div class="flex-1 min-w-0">
            <label
                for="category"
                class="block text-xs text-zinc-500"
            >
              Categoria permisului
            </label>

            <select v-model="category" class="w-full bg-transparent outline-none">
              <option
                  v-for="item in filters?.categories ?? []"
                  :key="item"
                  :value="item"
              >
                {{ item }}
              </option>
            </select>
          </div>
        </div>
        <div class="px-2 pb-2">
          <RouterLink
              :to="{
                path: '/schools',
                query: {
                  category,
                  ...(localityId ? { localityId } : {}),
                },
              }"
              class="flex w-full items-center justify-center gap-2 rounded-xl bg-purple-800 py-2.5 !text-white transition-all duration-200 hover:bg-purple-900"
          >
            <Search class="w-[18px] h-[18px]"/>
            <span class="font-medium">Caută școli</span>
          </RouterLink>
        </div>
      </div>
      <RouterLink
          to="/schools"
          class="mt-6 flex items-center gap-1">
        <span class="text-sm text-purple-800 font-semibold">Vezi toate scolile</span>
        <ArrowLeft class="h-4 w-4 rotate-180 stroke-purple-800"/>
      </RouterLink>
    </div>
    <PerformanceCard/>
  </section>
</template>

<style scoped>

</style>
