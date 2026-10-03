<script setup lang="ts">
defineProps<{
  isActive: boolean
}>()

const emit = defineEmits<{
  close: []
}>()
</script>

<template>
  <Transition name="mobile-menu">
    <nav
        v-if="isActive"
        class="bg-white border-b border-gray-200 md:hidden"
    >
      <ul class="px-6 py-4 flex flex-col gap-3">
        <li>
          <RouterLink
              class="font-semibold text-zinc-700"
              to="/"
              @click="emit('close')"
          >
            Scoli auto
          </RouterLink>
        </li>

        <li>
          <RouterLink
              class="font-semibold text-zinc-700"
              to="/compare"
              @click="emit('close')"
          >
            Compara
          </RouterLink>
        </li>

        <li>
          <RouterLink
              class="font-semibold text-zinc-700"
              to="/map"
              @click="emit('close')"
          >
            Harta
          </RouterLink>
        </li>

        <li>
          <RouterLink
              class="font-semibold text-zinc-700"
              to="/statistics"
              @click="emit('close')"
          >
            Statistici
          </RouterLink>
        </li>
      </ul>
    </nav>
  </Transition>
</template>

<style scoped>
.mobile-menu-enter-active,
.mobile-menu-leave-active {
  transition: 0.2s ease;
}

.mobile-menu-enter-from,
.mobile-menu-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}
</style>