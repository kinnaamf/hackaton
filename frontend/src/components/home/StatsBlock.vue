<script setup lang="ts">
import { onMounted, ref, computed } from 'vue';
import { getOverview } from '@/api/stats'
import type { Overview } from '@/types/api'

const overview = ref<Overview | null>(null)
const loading = ref<boolean>(true)

onMounted(async () => {
  try {
    overview.value = await getOverview()
  } finally {
    loading.value = false
  }
})

import {
  Building2,
  MapPin,
  Users,
  ChartNoAxesColumnIncreasing
} from '@lucide/vue'

const stats = computed(() => [
  {
    id: 1,
    value: overview.value?.schoolsCount ?? '-',
    label: 'Școli auto',
    icon: Building2,
  },
  {
    id: 2,
    value: overview.value?.localitiesCount ?? '-',
    label: 'Localități',
    icon: MapPin,
  },
  {
    id: 3,
    value: overview.value?.candidatesCount?.toLocaleString('ro-MD') ?? '-',
    label: 'Candidați analizați',
    icon: Users,
  },
  {
    id: 4,
    value: overview.value?.practicePassRate != null
        ? `${overview.value.practicePassRate}%`
        : '-',
    label: 'Promovare practică',
    icon: ChartNoAxesColumnIncreasing,
  },
])
</script>

<template>
  <section class="w-full">
    <div
        class="border-y border-slate-200 py-4">
      <div
          class="grid grid-cols-2 lg:grid-cols-4"
      >
        <div
            v-for="(stat, index) in stats"
            :key="stat.id"
            class="flex items-center gap-4 px-3 py-3 md:px-4
                 lg:py-0
                 lg:border-r lg:border-slate-200
                 last:lg:border-r-0"
        >
          <component
              :is="stat.icon"
              class="w-5 h-5 shrink-0 text-purple-700"
              :stroke-width="1.7"
          />

          <div>
            <div
                class="text-xl md:text-2xl font-bold
                     leading-none text-slate-900"
            >
              {{ index === 2 ? `${stat.value}+` : stat.value}}
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
