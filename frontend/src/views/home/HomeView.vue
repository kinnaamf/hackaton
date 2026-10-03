<script setup lang="ts">

import HeroSection from "@/views/home/sections/HeroSection.vue";
import StatsBlock from "@/components/home/StatsBlock.vue";
import RankingSection from "@/views/home/sections/RankingSection.vue";
import HowItWorksSection from "@/views/home/sections/HowItWorksSection.vue";
</script>

<template>
  <div class="flex flex-col gap-16">
    <HeroSection/>
    <StatsBlock/>
    <RankingSection/>
    <HowItWorksSection class="pb-12"/>
  </div>
</template>

<style scoped>

</style>