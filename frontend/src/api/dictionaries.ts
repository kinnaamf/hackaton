import { api } from './client'
import type { Filters } from '@/types/api'

export function getFilters() {
    return api<Filters>('/filters')
}