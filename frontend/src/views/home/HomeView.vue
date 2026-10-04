<script setup lang="ts">

import HeroSection from "@/views/home/sections/HeroSection.vue";
import StatsBlock from "@/components/home/StatsBlock.vue";
import RankingSection from "@/views/home/sections/RankingSection.vue";
import HowItWorksSection from "@/views/home/sections/HowItWorksSection.vue";
</script>

<template>
  <div class="flex flex-col gap-12 pb-12 md:gap-16 md:pb-16">
    <HeroSection/>
    <StatsBlock/>
    <RankingSection/>
    <HowItWorksSection/>
  </div>
</template>

<style scoped>

</style>
