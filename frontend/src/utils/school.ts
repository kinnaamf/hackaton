import type { SchoolCard } from '@/types/school-card'

export function schoolSlug(school: Pick<SchoolCard, 'id' | 'name'>) {
  const name = school.name
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')

  return `${name || 'scoala'}-${school.id}`
}

export function schoolProfilePath(school: Pick<SchoolCard, 'id' | 'name'>) {
  return `/schools/${schoolSlug(school)}`
}

export function schoolIdFromSlug(slug: string) {
  const match = slug.match(/-(\d+)$/)
  return match ? Number(match[1]) : null
}
