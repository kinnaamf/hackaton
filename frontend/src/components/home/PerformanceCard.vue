<script setup lang="ts">
import { computed } from 'vue'
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

const school = {
  name: 'Autoșcoala Vector',
  category: 'B',
  year: 2025,
  rank: 4,

  stats: {
    theoryPassRate: 78.4,
    practicePassRate: 64.7,
    firstTryPracticeRate: 58.2,
    averageAttempts: 1.7,
  },

  performance: [
    { month: 'Ian', theory: 58, practice: 42 },
    { month: 'Feb', theory: 61, practice: 45 },
    { month: 'Mar', theory: 64, practice: 49 },
    { month: 'Apr', theory: 70, practice: 55 },
    { month: 'Mai', theory: 68, practice: 53 },
    { month: 'Iun', theory: 74, practice: 60 },
    { month: 'Iul', theory: 71, practice: 58 },
    { month: 'Aug', theory: 77, practice: 63 },
    { month: 'Sep', theory: 75, practice: 61 },
    { month: 'Oct', theory: 79, practice: 67 },
    { month: 'Nov', theory: 78, practice: 67 },
    { month: 'Dec', theory: 84, practice: 71 },
  ],
}

const chartData = computed(() => ({
  labels: school.performance.map(item => item.month),

  datasets: [
    {
      label: 'Teorie',
      data: school.performance.map(item => item.theory),

      borderColor: '#536fe8',
      backgroundColor: 'rgba(83, 111, 232, 0.08)',

      borderWidth: 2.5,
      tension: 0.42,

      fill: true,

      pointRadius: 0,
      pointHitRadius: 20,

      pointHoverRadius: 4,
      pointHoverBorderWidth: 2,
      pointHoverBackgroundColor: '#ffffff',
      pointHoverBorderColor: '#536fe8',
    },

    {
      label: 'Practică',
      data: school.performance.map(item => item.practice),

      borderColor: '#74ad9c',
      backgroundColor: 'transparent',

      borderWidth: 2.5,
      tension: 0.42,

      fill: false,

      pointRadius: 0,
      pointHitRadius: 20,

      pointHoverRadius: 4,
      pointHoverBorderWidth: 2,
      pointHoverBackgroundColor: '#ffffff',
      pointHoverBorderColor: '#74ad9c',
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
      class="
      mt-8
      w-full
      xl:w-[640px]
      overflow-hidden
      rounded-[20px]
      bg-white
      shadow-xs
    "
  >
    <!-- Content -->
    <div class="px-5 pt-5">
      <!-- Header -->
      <div class="flex items-start justify-between gap-4">
        <div class="min-w-0">
          <span
              class="
              text-[11px]
              font-semibold
              uppercase
              tracking-[0.12em]
              text-slate-500
            "
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
            {{ school.name }}
          </h3>

          <p class="mt-1 text-[15px] text-slate-500">
            Categoria {{ school.category }} · {{ school.year }}
          </p>
        </div>

        <div
            class="
            flex
            h-9
            shrink-0
            items-center
            justify-center
            rounded-lg
            bg-indigo-50
            px-3
            text-sm
            font-bold
            text-indigo-600
          "
        >
          #{{ school.rank }}
        </div>
      </div>

      <!-- Stats -->
      <div class="mt-7 grid grid-cols-2">
        <!-- Theory -->
        <div class="border-r border-slate-200 pb-4 pr-4">
          <p class="text-[18px] font-bold leading-none text-slate-800">
            {{ school.stats.theoryPassRate }}%
          </p>

          <p class="mt-2 text-[11px] leading-tight text-slate-500">
            Promovare teorie
          </p>
        </div>

        <!-- Practice -->
        <div class="pb-4 pl-4">
          <p class="text-[18px] font-bold leading-none text-slate-800">
            {{ school.stats.practicePassRate }}%
          </p>

          <p class="mt-2 text-[11px] leading-tight text-slate-500">
            Promovare practică
          </p>
        </div>

        <!-- First try -->
        <div class="border-r border-slate-200 pr-4 pt-1">
          <p class="text-[18px] font-bold leading-none text-slate-800">
            {{ school.stats.firstTryPracticeRate }}%
          </p>

          <p class="mt-2 text-[11px] leading-tight text-slate-500">
            Practică din prima
          </p>
        </div>

        <!-- Attempts -->
        <div class="pl-4 pt-1">
          <p class="text-[18px] font-bold leading-none text-slate-800">
            {{ school.stats.averageAttempts }}
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