export interface Overview {
    year: number | null
    schoolsCount: number
    localitiesCount: number
    candidatesCount: number
    theoryPassRate: number | null
    practicePassRate: number | null
}

export interface Filters {
    localities: Array<{
        id: number
        name: string
        district: string
        schoolsCount: number
    }>
    categories: string[]
    years: number[]
}

export interface Performance {
    schoolId: number
    name: string
    category: string
    year: number
    rank: number | null
    stats: {
        theoryPassRate: number | null
        practicePassRate: number | null
        practiceFirstTryRate: number | null
        averageAttempts: number | null
    }
    performance: Array<{
        month: number
        theory: number | null
        practice: number | null
        firstTryPractice: number | null
        candidatesCount: number
    }>
}