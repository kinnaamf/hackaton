import { api } from './client'
import type { SchoolCard } from '@/types/school-card'
import type { Performance } from "@/types/api"
import type { SchoolProfile, SchoolReview } from '@/types/school-profile'

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

export function getSchool(schoolId: number) {
    return api<SchoolProfile>(`/schools/${schoolId}`)
}

export function getSchoolPerformance(schoolId: number, category = 'B', year?: number) {
    return api<Performance>(`/schools/${schoolId}/performance`, {
        query: { category, ...(year ? { year } : {}) },
    })
}

export function getSchoolReviews(schoolId: number) {
    return api<{ total: number; items: SchoolReview[] }>(`/schools/${schoolId}/reviews`)
}
