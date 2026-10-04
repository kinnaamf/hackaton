import { api } from './client'
import type { FrequentErrors, Overview } from '@/types/api'

export function getOverview(year?: number) {
    return api<Overview>('/stats/overview', {
        query: year ? { year } : undefined,
    })
}

export function getFrequentErrors(category?: string, year?: number, limit = 4) {
    return api<FrequentErrors>('/stats/frequent-errors', {
        query: { limit, ...(category ? { category } : {}), ...(year ? { year } : {}) },
    })
}