<script setup lang="ts">

import AppHeader from "@/components/layout/AppHeader.vue";
import AppFooter from "@/components/layout/AppFooter.vue";
</script>

<template>
  <header>
    <AppHeader class="sticky left-0 top-0"/>
  </header>
  <main class="mx-auto max-w-[1440px] px-5 md:px-8 lg:px-12">
    <RouterView/>
  </main>
  <footer>
    <AppFooter/>
  </footer>
</template>

<style scoped></style>
