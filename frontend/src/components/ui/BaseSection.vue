<script setup lang="ts">
defineProps<{
  badge?: string
  title: string
  paragraph?: string
}>()
</script>

<template>
  <section class="w-full px-6">
    <div class="mb-8 flex items-end justify-between gap-6">
      <div>
        <span
            v-if="badge"
            class="text-xs font-semibold uppercase tracking-wider text-indigo-600"
        >
          {{ badge }}
        </span>

        <h2 class="mt-2 text-3xl font-semibold text-slate-900">
          {{ title }}
        </h2>

        <p
            v-if="paragraph"
            class="mt-2 text-base text-slate-500"
        >
          {{ paragraph }}
        </p>
      </div>

      <div
          v-if="$slots.actions"
          class="shrink-0"
      >
        <slot name="actions" />
      </div>
    </div>

    <slot />
  </section>
</template>