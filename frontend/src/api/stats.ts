import { api } from './client'
import type { Overview } from '@/types/api'

export function getOverview(year?: number) {
    return api<Overview>('/stats/overview', {
        query: year ? { year } : undefined,
    })
}