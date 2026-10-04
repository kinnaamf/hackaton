import { ref } from 'vue'
import type { SchoolCard } from '@/types/school-card'

const storageKey = 'auto-edu-compare-schools'

function readStoredSchools(): SchoolCard[] {
  if (typeof window === 'undefined') return []

  try {
    return JSON.parse(window.localStorage.getItem(storageKey) ?? '[]') as SchoolCard[]
  } catch {
    return []
  }
}

export const comparedSchools = ref<SchoolCard[]>(readStoredSchools())

function persist() {
  window.localStorage.setItem(storageKey, JSON.stringify(comparedSchools.value))
}

export function addSchoolToCompare(school: SchoolCard): 'added' | 'exists' | 'full' {
  if (comparedSchools.value.some((item) => item.id === school.id)) return 'exists'
  if (comparedSchools.value.length >= 3) return 'full'

  comparedSchools.value = [...comparedSchools.value, school]
  persist()
  return 'added'
}

export function removeSchoolFromCompare(schoolId: number) {
  comparedSchools.value = comparedSchools.value.filter((school) => school.id !== schoolId)
  persist()
}
