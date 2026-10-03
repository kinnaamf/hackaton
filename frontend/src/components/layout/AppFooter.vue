<script setup lang="ts">
const footerGroups = [
  {
    title: 'Platformă',
    links: [
      { label: 'Școli auto', to: '/schools' },
      { label: 'Compară școli', to: '/compare' },
      { label: 'Hartă', to: '/map' },
      { label: 'Statistici', to: '/statistics' },
    ],
  },
  {
    title: 'Resurse',
    links: [
      { label: 'Metodologie', to: '/methodology' },
      { label: 'Cum funcționează', to: '/how-it-works' },
      { label: 'Despre date', to: '/data' },
      { label: 'Întrebări frecvente', to: '/faq' },
    ],
  },
  {
    title: 'Informații',
    links: [
      { label: 'Despre proiect', to: '/about' },
      { label: 'Contact', to: '/contact' },
      { label: 'Politica de confidențialitate', to: '/privacy' },
      { label: 'Termeni și condiții', to: '/terms' },
    ],
  },
]

const currentYear = new Date().getFullYear()
</script>

<template>
  <footer class="border-t border-slate-200 bg-white pt-12 pb-6">
    <div class="mx-auto max-w-[1440px]">

      <!-- Main footer -->
      <div class="grid grid-cols-1 gap-10 md:grid-cols-2 lg:grid-cols-[2fr_1fr_1fr_1fr] lg:gap-12">

        <!-- Brand -->
        <div>
          <img
              src="/logo.png"
              alt="Path Drive"
              class="h-12 w-40 object-contain"
          >

          <p class="mt-4 max-w-xs text-sm leading-6 text-slate-500">
            Date publice și rezultate reale pentru o alegere
            informată a școlii auto din Moldova.
          </p>
        </div>

        <!-- Platformă -->
        <div>
          <h3 class="font-semibold text-slate-900">
            Platformă
          </h3>

          <ul class="mt-4 space-y-3 text-sm text-slate-700">
            <li><RouterLink to="/schools">Școli auto</RouterLink></li>
            <li><RouterLink to="/compare">Compară școli</RouterLink></li>
            <li><RouterLink to="/map">Hartă</RouterLink></li>
            <li><RouterLink to="/statistics">Statistici</RouterLink></li>
          </ul>
        </div>

        <!-- Resurse -->
        <div>
          <h3 class="font-semibold text-slate-900">
            Resurse
          </h3>

          <ul class="mt-4 space-y-3 text-sm text-slate-700">
            <li><RouterLink to="/methodology">Metodologie</RouterLink></li>
            <li><RouterLink to="/how-it-works">Cum funcționează</RouterLink></li>
            <li><RouterLink to="/data">Despre date</RouterLink></li>
            <li><RouterLink to="/faq">Întrebări frecvente</RouterLink></li>
          </ul>
        </div>

        <!-- Informații -->
        <div>
          <h3 class="font-semibold text-slate-900">
            Informații
          </h3>

          <ul class="mt-4 space-y-3 text-sm text-slate-700">
            <li><RouterLink to="/about">Despre proiect</RouterLink></li>
            <li><RouterLink to="/contact">Contact</RouterLink></li>
            <li><RouterLink to="/privacy">Politica de confidențialitate</RouterLink></li>
            <li><RouterLink to="/terms">Termeni și condiții</RouterLink></li>
          </ul>
        </div>

      </div>

      <!-- Bottom -->
      <div
          class="mt-8 py-4 flex flex-col gap-3
               border-t border-slate-200
               md:flex-row md:items-center md:justify-between"
      >
        <p class="text-xs text-slate-500">
          © {{ currentYear }} Path Drive. Toate drepturile rezervate.
        </p>

        <p class="text-xs text-slate-400">
          Date publice pentru o alegere informată.
        </p>
      </div>

    </div>
  </footer>
</template>