<script setup lang="ts">
import {
  Building2,
  MapPin,
  Users,
  ChartNoAxesColumnIncreasing
} from '@lucide/vue'

const stats = [
  {
    id: 1,
    value: '186',
    label: 'Școli auto',
    icon: Building2,
  },
  {
    id: 2,
    value: '24',
    label: 'Localități',
    icon: MapPin,
  },
  {
    id: 3,
    value: '12 480',
    label: 'Candidați analizați',
    icon: Users,
  },
  {
    id: 4,
    value: '61.8%',
    label: 'Promovare practică',
    icon: ChartNoAxesColumnIncreasing,
  },
]
</script>

<template>
  <section class="">
    <div
        class="
             border-y border-slate-200
             py-6"
    >
      <div
          class="grid grid-cols-2 lg:grid-cols-4"
      >
        <div
            v-for="(stat, index) in stats"
            :key="stat.id"
            class="flex items-center gap-4 px-4 py-3
                 lg:py-0
                 lg:border-r lg:border-slate-200
                 last:lg:border-r-0"
        >
          <component
              :is="stat.icon"
              class="w-5 h-5 shrink-0 text-indigo-500"
              :stroke-width="1.7"
          />

          <div>
            <div
                class="text-xl md:text-2xl font-bold
                     leading-none text-slate-900"
            >
              {{ stat.value }}
            </div>

            <div class="mt-1 text-xs text-slate-500">
              {{ stat.label }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>