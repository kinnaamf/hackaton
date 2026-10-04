export interface SchoolProfile {
  id: number
  name: string
  shortName: string | null
  verified: boolean
  legalForm: string | null
  licenseNumber: string | null
  licenseExpiryDate: string | null
  foundedYear: number | null
  description: string | null
  city: string | null
  district: string | null
  address: string | null
  latitude: number | null
  longitude: number | null
  phone: string | null
  email: string | null
  website: string | null
  hasOwnTrainingGround: boolean
  instructorsCount: number
  vehiclesCount: number
  categories: Array<{ code: string; price: number | null; currency: string | null; theoryHours: number | null; practiceHours: number | null; durationWeeks: number | null }>
  branches: Array<{ id: number; name: string; city: string; address: string; latitude: number | null; longitude: number | null; phone: string | null; hasTrainingGround: boolean }>
  stats: Array<{ category: string; year: number; rank: number | null; candidatesCount: number; theoryPassRate: number | null; theoryFirstTryRate: number | null; practicePassRate: number | null; practiceFirstTryRate: number | null; averageAttempts: number | null; averagePenaltyPoints: number | null }>
  rating: { overall: number | null; theory: number | null; practice: number | null; instructors: number | null; vehicles: number | null; price: number | null; reviewsCount: number }
}

export interface SchoolReview {
  id: number
  author: string | null
  category: string | null
  ratingOverall: number
  title: string | null
  comment: string | null
  isVerifiedGraduate: boolean
  createdAt: string
}
