import { api } from './client'
import type { SchoolCard } from '@/types/school-card'
import type { Performance } from "@/types/api"

type SchoolList = {
    total: number
    items: SchoolCard[]
}

export function getSchools(params: {
    category?: string
    year?: number
    localityId?: number
    sort?: 'rank' | 'theory' | 'practice' | 'firstTry' | 'rating' | 'price' | 'candidates'
    limit?: number
}) {
    return api<SchoolList>('/schools', { query: params })
}

export function getFeatured(category = 'B', year?: number) {
    return api<Performance>('/schools/featured', {
        query: { category, ...(year ? { year } : {}) },
    })
}