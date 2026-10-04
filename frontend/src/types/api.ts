export interface Overview {
    year: number | null
    schoolsCount: number
    localitiesCount: number
    candidatesCount: number
    theoryPassRate: number | null
    practicePassRate: number | null
}

export interface FrequentError {
    description: string
    practiceType: string | null
    points: number
    isEliminatory: boolean
    count: number
    percent: number
    attemptsPercent: number
}

export interface FrequentErrors {
    year: number | null
    category: string | null
    schoolId: number | null
    attemptsCount: number
    penaltiesCount: number
    items: FrequentError[]
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