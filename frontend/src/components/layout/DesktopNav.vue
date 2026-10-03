<script setup lang="ts">
</script>
<template>
  <nav class="hidden md:block h-full">
    <ul class="flex items-center gap-6 h-full">
      <li class="h-full">
        <RouterLink
            to="/"
            class="relative flex items-center h-full
                 !text-zinc-500 font-semibold
                 transition-colors duration-300
                 hover:text-zinc-800
                 after:absolute after:bottom-0 after:left-0
                 after:h-0.5 after:w-0 after:bg-purple-800
                 after:transition-all after:duration-300
                 hover:after:w-full"
        >
          Scoli auto
        </RouterLink>
      </li>

      <li class="h-full">
        <RouterLink
            to="/"
            class="relative flex items-center h-full
                 !text-zinc-500 font-semibold
                 transition-colors duration-300
                 hover:text-zinc-800
                 after:absolute after:bottom-0 after:left-0
                 after:h-0.5 after:w-0 after:bg-purple-800
                 after:transition-all after:duration-300
                 hover:after:w-full"
        >
          Compara
        </RouterLink>
      </li>

      <li class="h-full">
        <RouterLink
            to="/"
            class="relative flex items-center h-full
                 !text-zinc-500 font-semibold
                 transition-colors duration-300
                 hover:text-zinc-800
                 after:absolute after:bottom-0 after:left-0
                 after:h-0.5 after:w-0 after:bg-purple-800
                 after:transition-all after:duration-300
                 hover:after:w-full"
        >
          Harta
        </RouterLink>
      </li>

      <li class="h-full">
        <RouterLink
            to="/compare"
            class="relative flex items-center h-full
                 !text-zinc-500 font-semibold
                 transition-colors duration-300
                 hover:text-zinc-800
                 after:absolute after:bottom-0 after:left-0
                 after:h-0.5 after:w-0 after:bg-purple-800
                 after:transition-all after:duration-300
                 hover:after:w-full"
        >
          Statistici
        </RouterLink>
      </li>
    </ul>
  </nav>
</template>