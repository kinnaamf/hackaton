<script setup lang="ts">
import { ref, useTemplateRef } from 'vue'
import { onClickOutside } from "@vueuse/core";
import { Menu, X } from '@lucide/vue'
import DesktopNav from './DesktopNav.vue'
import MobileNav from './MobileNav.vue'

const header = useTemplateRef<HTMLElement | null>('header')

onClickOutside(header, () => {
  isActive.value = false
})

const isActive = ref(false)
</script>

<template>
  <header class="w-full bg-white"
          ref="header"
          :class="{ 'border-b border-gray-200': !isActive }"
  >
    <div
        class="h-16 md:h-20 max-w-360 mx-auto flex items-center justify-between bg-white px-6"
    >
      <RouterLink to="/">
        <img
            src="/logo.png"
            alt="Logo"
            class="h-12 w-40 object-cover"
        >
      </RouterLink>

      <DesktopNav />

      <button
          class="md:hidden cursor-pointer"
          type="button"
          aria-label="Toggle navigation"
          @click="isActive = !isActive"
      >
        <X v-if="isActive" />
        <Menu v-else />
      </button>
    </div>

    <MobileNav
        :is-active="isActive"
        @close="isActive = false"
    />
  </header>
</template>