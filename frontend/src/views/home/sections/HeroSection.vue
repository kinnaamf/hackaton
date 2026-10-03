<script setup lang="ts">
import {ref} from 'vue'
import {MapPin, GraduationCap, Search, ArrowLeft } from '@lucide/vue'
import PerformanceCard from "@/components/home/PerformanceCard.vue";

const location = ref('Chișinău')
const category = ref('B')

const locations = [
  'Chișinău',
  'Bălți',
  'Cahul',
  'Orhei',
  'Ungheni',
]

const categories = ['A', 'B', 'C', 'CE']
</script>

<template>
  <section class="flex flex-col md:flex-row items-center gap-6 lg:gap-16 xl:justify-between pt-12">
    <div>
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
      <div class="bg-white rounded-2xl mt-8 overflow-hidden shadow-xs max-w-[420px]">

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
                v-model="location"
                class="block w-full bg-transparent font-semibold text-zinc-800 outline-none cursor-pointer"
            >
              <option value="Chișinău">Chișinău</option>
              <option value="Bălți">Bălți</option>
              <option value="Cahul">Cahul</option>
              <option value="Orhei">Orhei</option>
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
                  v-for="item in categories"
                  :key="item"
                  :value="item"
              >
                {{ item }}
              </option>
            </select>
          </div>
        </div>
        <div class="px-2 pb-2">
          <button
              class="flex justify-center py-2.5 items-center gap-2 bg-purple-800 hover:bg-purple-900 transition-all duration-200 w-full text-white rounded-xl">
            <Search class="w-[18px] h-[18px]"/>
            <span class="font-medium">Caută școli</span>
          </button>
        </div>
      </div>
      <RouterLink
          to=""
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