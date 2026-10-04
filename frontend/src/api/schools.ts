import { api } from './client'
import type { SchoolCard } from '@/types/school-card'
import type { Performance } from "@/types/api"

export type SchoolList = {
    total: number
    items: SchoolCard[]
}

export interface SchoolLocation extends SchoolCard {
    latitude: number | null
    longitude: number | null
}

export function getSchools(params: {
    category?: string
    year?: number
    localityId?: number
    search?: string
    sort?: 'rank' | 'theory' | 'practice' | 'firstTry' | 'rating' | 'price' | 'candidates'
    limit?: number
    offset?: number
}) {
    const { localityId, ...query } = params

    return api<SchoolList>('/schools', {
        query: {
            ...query,
            locality_id: localityId,
        },
    })
}

export function getFeatured(category = 'B', year?: number) {
    return api<Performance>('/schools/featured', {
        query: { category, ...(year ? { year } : {}) },
    })
}

export function getSchoolLocation(schoolId: number) {
    return api<SchoolLocation>(`/schools/${schoolId}`)
}
