<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

type InfoPage = {
  eyebrow: string
  title: string
  intro: string
  sections: Array<{ title: string, text: string }>
}

const pages: Record<string, InfoPage> = {
  methodology: {
    eyebrow: 'Resurse', title: 'Metodologie',
    intro: 'Explicăm clar cum sunt calculate și afișate datele din platformă.',
    sections: [
      { title: 'Indicatori comparabili', text: 'Ratele de promovare sunt calculate separat pentru teorie, practică și prima încercare, pentru aceeași categorie și perioadă.' },
      { title: 'Clasament', text: 'Poziția în clasament este informativă și se bazează pe datele raportate pentru categoria și anul selectate.' },
      { title: 'Actualizare', text: 'Datele sunt actualizate atunci când apar raportări noi. O valoare poate diferi între ani sau categorii.' },
    ],
  },
  'how-it-works': {
    eyebrow: 'Resurse', title: 'Cum funcționează',
    intro: 'Path Drive te ajută să alegi o școală auto pe baza unor informații ușor de comparat.',
    sections: [
      { title: 'Alege categoria', text: 'Selectează categoria permisului și localitatea care te interesează.' },
      { title: 'Compară rezultatele', text: 'Vezi ratele de promovare, prețurile, recenziile și poziția în clasament.' },
      { title: 'Alege informat', text: 'Deschide profilul unei școli pentru detalii despre oferte, rezultate și date de contact.' },
    ],
  },
  data: {
    eyebrow: 'Resurse', title: 'Despre date',
    intro: 'Platforma folosește date publice și date raportate despre activitatea școlilor auto.',
    sections: [
      { title: 'Ce afișăm', text: 'Afișăm școli, categorii de instruire, localități, rezultate ale examenelor și informații despre oferte.' },
      { title: 'Cum le interpretăm', text: 'Rezultatele reprezintă indicatori statistici. Ele nu garantează rezultatul individual al unui candidat.' },
      { title: 'Corectarea datelor', text: 'Dacă observi o neconcordanță, transmite-ne detaliile prin pagina de contact.' },
    ],
  },
  faq: {
    eyebrow: 'Resurse', title: 'Întrebări frecvente',
    intro: 'Răspunsuri scurte la cele mai des întâlnite întrebări despre platformă.',
    sections: [
      { title: 'De ce ratele diferă între școli?', text: 'Fiecare școală are un număr diferit de candidați, categorii și încercări de examen.' },
      { title: 'Ce înseamnă prima încercare?', text: 'Este procentul candidaților care au promovat fără a avea nevoie de o repetare a probei.' },
      { title: 'Pot compara școli?', text: 'Da. Adaugă până la trei școli în lista de comparație și analizează indicatorii împreună.' },
    ],
  },
  about: {
    eyebrow: 'Informații', title: 'Despre proiect',
    intro: 'Path Drive face mai simplă alegerea unei școli auto din Moldova.',
    sections: [
      { title: 'Scopul nostru', text: 'Reunim informații utile într-un singur loc, pentru ca alegerea unei școli să fie mai transparentă.' },
      { title: 'Pentru cine este', text: 'Pentru viitorii conducători auto, familiile lor și oricine vrea să compare școli pe criterii concrete.' },
      { title: 'Principii', text: 'Punem accent pe claritate, comparabilitate și prezentarea responsabilă a datelor publice.' },
    ],
  },
  contact: {
    eyebrow: 'Informații', title: 'Contact',
    intro: 'Ai o întrebare sau ai găsit o informație care trebuie corectată?',
    sections: [
      { title: 'Scrie-ne', text: 'Trimite-ne un mesaj la contact@pathdrive.md și descrie cât mai clar întrebarea sau corectarea propusă.' },
      { title: 'Actualizarea profilului', text: 'Reprezentanții școlilor pot semnala modificări ale datelor de contact, programelor și ofertelor.' },
      { title: 'Timp de răspuns', text: 'Analizăm mesajele primite și revenim atunci când sunt necesare clarificări suplimentare.' },
    ],
  },
  privacy: {
    eyebrow: 'Informații', title: 'Politica de confidențialitate',
    intro: 'Respectăm confidențialitatea persoanelor care folosesc platforma.',
    sections: [
      { title: 'Date colectate', text: 'Platforma nu solicită crearea unui cont pentru consultarea informațiilor publice despre școli.' },
      { title: 'Mesaje de contact', text: 'Datele transmise prin e-mail sunt folosite numai pentru a răspunde solicitării tale.' },
      { title: 'Cookie-uri', text: 'Pot fi folosite date tehnice strict necesare pentru funcționarea și îmbunătățirea site-ului.' },
    ],
  },
  terms: {
    eyebrow: 'Informații', title: 'Termeni și condiții',
    intro: 'Prin folosirea platformei accepți condițiile de mai jos.',
    sections: [
      { title: 'Scop informativ', text: 'Informațiile sunt oferite pentru comparație și orientare. Decizia de alegere a unei școli îți aparține.' },
      { title: 'Utilizarea conținutului', text: 'Nu este permisă copierea sistematică sau folosirea datelor în scop comercial fără acord.' },
      { title: 'Modificări', text: 'Putem actualiza conținutul și acești termeni când este necesar pentru funcționarea platformei.' },
    ],
  },
}

const route = useRoute()
const page = computed<InfoPage>(() => pages[String(route.meta.page)] ?? pages.about!)
</script>

<template>
  <section class="py-10 md:py-16">
    <div class="mx-auto max-w-3xl">
      <p class="text-xs font-bold uppercase tracking-[0.14em] text-purple-800">{{ page.eyebrow }}</p>
      <h1 class="mt-3 text-3xl font-semibold tracking-tight text-slate-900 md:text-4xl">{{ page.title }}</h1>
      <p class="mt-4 max-w-2xl text-base leading-7 text-slate-600">{{ page.intro }}</p>

      <div class="mt-10 divide-y py-4 divide-slate-200 border-y border-slate-200">
        <article v-for="section in page.sections" :key="section.title" class="py-7 first:pt-0 last:pb-0">
          <h2 class="text-lg font-semibold text-slate-900">{{ section.title }}</h2>
          <p class="mt-2 leading-7 text-slate-600">{{ section.text }}</p>
        </article>
      </div>
    </div>
  </section>
</template>
