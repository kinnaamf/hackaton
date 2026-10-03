export interface SchoolCard {
    id: number
    name: string
    verified: boolean

    city: string
    address: string

    categories: string[]
    hasOwnTrainingGround: boolean

    theoryPassRate: number
    practicePassRate: number
    firstTryPassRate: number

    rank: number
    rating: number
    reviewsCount: number

    candidatesCount: number
    priceFrom: number
}