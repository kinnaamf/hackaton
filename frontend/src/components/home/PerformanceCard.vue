<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { getFeatured } from '@/api/schools'
import type { Performance } from '@/types/api'
import { schoolProfilePath } from '@/utils/school'
import { Line } from 'vue-chartjs'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Filler,
  Tooltip,
  Legend,
  type ChartOptions,
} from 'chart.js'

ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Filler,
    Tooltip,
    Legend,
)

const featured = ref<Performance | null>(null)

const monthNames = [
  '', 'Ian', 'Feb', 'Mar', 'Apr', 'Mai', 'Iun',
  'Iul', 'Aug', 'Sep', 'Oct', 'Noi', 'Dec',
]

onMounted(async () => {
  featured.value = await getFeatured('B', 2025)
})

function formatPercent(value: number | null | undefined) {
  return value == null ? '—' : `${Math.round(value)}%`
}

const chartData = computed(() => ({
  labels: (featured.value?.performance ?? []).map(
      (item) => monthNames[item.month],
  ),

  datasets: [
    {
      label: 'Teorie',
      data: (featured.value?.performance ?? []).map((item) => item.theory),
      borderColor: '#536fe8',
      backgroundColor: 'rgba(83, 111, 232, 0.08)',
      borderWidth: 2.5,
      tension: 0.42,
      fill: true,
      pointRadius: 0,
    },
    {
      label: 'Practică',
      data: (featured.value?.performance ?? []).map((item) => item.practice),
      borderColor: '#74ad9c',
      backgroundColor: 'transparent',
      borderWidth: 2.5,
      tension: 0.42,
      fill: false,
      pointRadius: 0,
    },
  ],
}))

const chartOptions: ChartOptions<'line'> = {
  responsive: true,
  maintainAspectRatio: false,

  animation: {
    duration: 700,
  },

  interaction: {
    mode: 'index',
    intersect: false,
  },

  layout: {
    padding: {
      top: 8,
      left: 5,
      right: 5,
    },
  },

  plugins: {
    legend: {
      display: false,
    },

    tooltip: {
      enabled: false,
    },
  },

  scales: {
    x: {
      display: false,
      grid: {
        display: false,
      },
      border: {
        display: false,
      },
    },

    y: {
      display: false,

      suggestedMin: 30,
      suggestedMax: 90,

      grid: {
        display: false,
      },
      border: {
        display: false,
      },
    },
  },
}
</script>

<template>
  <div
      v-if="featured"
      class="mt-8 w-full xl:w-[640px] overflow-hidden rounded-[20px] bg-white shadow-xs"

  >
    <!-- Content -->
    <div class="px-5 pt-5">
      <!-- Header -->
      <div class="flex items-start justify-between gap-4">
        <div class="min-w-0">
          <span class=" text-[11px] font-semibold uppercase tracking-[0.12em] text-slate-500"
          >
            Exemplu de performanță
          </span>

          <h3
              class="
              mt-4
              truncate
              text-[20px]
              font-medium
              leading-tight
              text-slate-800
            "
          >
            <RouterLink :to="schoolProfilePath({ id: featured.schoolId, name: featured.name })" class="hover:text-purple-800">{{ featured.name }}</RouterLink>
          </h3>

          <p class="mt-1 text-[15px] text-slate-500">
            Categoria {{ featured.category }} · {{ featured.year }}
          </p>
        </div>

        <div
            class="flex h-9 shrink-0 items-center justify-center rounded-lg bg-purple-50 px-3 text-sm font-bold text-purple-800"
        >
          #{{ featured.rank }}
        </div>
      </div>

      <!-- Stats -->
      <div class="mt-7 grid grid-cols-2">
        <!-- Theory -->
        <div class="border-r border-slate-200 pb-4 pr-4">
          <p class="text-[18px] font-bold leading-none text-slate-800">
            {{ formatPercent(featured.stats.theoryPassRate) }}
          </p>

          <p class="mt-2 text-[11px] leading-tight text-slate-500">
            Promovare teorie
          </p>
        </div>

        <!-- Practice -->
        <div class="pb-4 pl-4">
          <p class="text-[18px] font-bold leading-none text-slate-800">
            {{ formatPercent(featured.stats.practicePassRate) }}
          </p>

          <p class="mt-2 text-[11px] leading-tight text-slate-500">
            Promovare practică
          </p>
        </div>

        <!-- First try -->
        <div class="border-r border-slate-200 pr-4 pt-1">
          <p class="text-[18px] font-bold leading-none text-slate-800">
            {{ formatPercent(featured.stats.practiceFirstTryRate) }}
          </p>

          <p class="mt-2 text-[11px] leading-tight text-slate-500">
            Practică din prima
          </p>
        </div>

        <!-- Attempts -->
        <div class="pl-4 pt-1">
          <p class="text-[18px] font-bold leading-none text-slate-800">
            {{ featured.stats.averageAttempts }}
          </p>

          <p class="mt-2 text-[11px] leading-tight text-slate-500">
            Încercări medii
          </p>
        </div>
      </div>
    </div>

    <!-- Chart -->
    <div class="mt-6 h-[120px] px-5">
      <Line
          :data="chartData"
          :options="chartOptions"
      />
    </div>

    <!-- Legend -->
    <div class="flex items-center gap-5 px-5 pb-5 pt-2">
      <div class="flex items-center gap-2">
        <span
            class="size-[7px] rounded-full bg-[#536fe8]"
        />

        <span class="text-[11px] text-slate-500">
          Teorie
        </span>
      </div>

      <div class="flex items-center gap-2">
        <span
            class="size-[7px] rounded-full bg-[#74ad9c]"
        />

        <span class="text-[11px] text-slate-500">
          Practică
        </span>
      </div>
    </div>
  </div>
</template>
