<script setup lang="ts">
import {
  GraduationCap,
  ChartNoAxesColumnIncreasing,
  CircleCheck,
} from '@lucide/vue'

import BaseSection from '@/components/ui/BaseSection.vue'

const steps = [
  {
    id: 1,
    number: '01',
    title: 'Alege categoria',
    description: 'Selectează categoria de permis și localitatea care te interesează.',
    icon: GraduationCap,
  },
  {
    id: 2,
    number: '02',
    title: 'Compară rezultatele',
    description: 'Analizează datele reale: promovare, prețuri și recenzii verificate.',
    icon: ChartNoAxesColumnIncreasing,
  },
  {
    id: 3,
    number: '03',
    title: 'Alege informat',
    description: 'Găsește școala potrivită pentru obiectivele tale.',
    icon: CircleCheck,
  },
]
</script>

<template>
  <BaseSection
      badge="Simplu și transparent"
      title="Cum funcționează"
  >
    <div class="grid grid-cols-3 gap-5 md:grid-cols-3">
      <article
          v-for="step in steps"
          :key="step.id"
          class="relative shadow-xs bg-white px-6 py-6 rounded-2xl"
      >
        <!-- Top -->
        <div class="flex items-center gap-4">
          <div
              class="flex items-center justify-center
                   rounded-lg bg-indigo-50 text-indigo-500 p-2"
          >
            <component
                :is="step.icon"
                class="h-5 w-5"
                :stroke-width="2"
            />
          </div>
          <h3 class="text-base font-medium text-slate-900">
            {{ step.title }}
          </h3>
        </div>

        <!-- Content -->
        <div class="mt-6">


          <p
              class="mt-2 max-w-xs text-sm leading-6 text-slate-500"
          >
            {{ step.description }}
          </p>
        </div>
      </article>
    </div>
  </BaseSection>
</template>