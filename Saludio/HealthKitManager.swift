import HealthKit
import Combine

class HealthKitManager: ObservableObject {
	private var healthStore = HKHealthStore()
	
	@Published var steps: Double = 0.0
	@Published var mindfulnessMinutes: Double = 0.0
	@Published var waterIntake: Double = 0.0
	@Published var activeCalories: Double = 0.0
	@Published var exerciseMinutes: Double = 0.0
	@Published var standHours: Double = 0.0
	
	func requestAuthorization() {
		let readTypes = Set([
			HKQuantityType.quantityType(forIdentifier: .stepCount)!,
			HKCategoryType.categoryType(forIdentifier: .mindfulSession)!,
			HKQuantityType.quantityType(forIdentifier: .dietaryWater)!,
			HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
			HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!,
			HKQuantityType.quantityType(forIdentifier: .appleStandTime)!
		])
		
		healthStore.requestAuthorization(toShare: [], read: readTypes) { (success, error) in
			if success {
				self.fetchSteps()
				self.fetchMindfulness()
				self.fetchWaterIntake()
				self.fetchActiveCalories()
				self.fetchExerciseMinutes()
				self.fetchStandHours()
			}
		}
	}
	
	func fetchSteps() {
		let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
		let startDate = Calendar.current.startOfDay(for: Date())
		let endDate = Date()
		
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
			guard let result = result, let sum = result.sumQuantity() else { return }
			let steps = sum.doubleValue(for: HKUnit.count())
			DispatchQueue.main.async {
				self.steps = steps
			}
		}
		healthStore.execute(query)
	}
	
	func fetchMindfulness() {
		let mindfulType = HKCategoryType.categoryType(forIdentifier: .mindfulSession)!
		let startDate = Calendar.current.startOfDay(for: Date())
		let endDate = Date()
		
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
			guard let samples = samples as? [HKCategorySample] else { return }
			let totalMinutes = samples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) / 60 }
			DispatchQueue.main.async {
				self.mindfulnessMinutes = totalMinutes
			}
		}
		healthStore.execute(query)
	}
	
	func fetchWaterIntake() {
		let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
		let startDate = Calendar.current.startOfDay(for: Date())
		let endDate = Date()
		
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		let query = HKStatisticsQuery(quantityType: waterType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
			guard let result = result, let sum = result.sumQuantity() else { return }
			let water = sum.doubleValue(for: HKUnit.literUnit(with: .milli))
			DispatchQueue.main.async {
				self.waterIntake = water
			}
		}
		healthStore.execute(query)
	}
	
	func fetchActiveCalories() {
		let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
		let startDate = Calendar.current.startOfDay(for: Date())
		let endDate = Date()
		
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		let query = HKStatisticsQuery(quantityType: caloriesType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
			guard let result = result, let sum = result.sumQuantity() else { return }
			let calories = sum.doubleValue(for: HKUnit.kilocalorie())
			DispatchQueue.main.async {
				self.activeCalories = calories
			}
		}
		healthStore.execute(query)
	}
	
	func fetchExerciseMinutes() {
		let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
		let startDate = Calendar.current.startOfDay(for: Date())
		let endDate = Date()
		
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		let query = HKStatisticsQuery(quantityType: exerciseType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
			guard let result = result, let sum = result.sumQuantity() else { return }
			let exerciseMinutes = sum.doubleValue(for: HKUnit.minute())
			DispatchQueue.main.async {
				self.exerciseMinutes = exerciseMinutes
			}
		}
		healthStore.execute(query)
	}
	
	func fetchStandHours() {
		let standType = HKQuantityType.quantityType(forIdentifier: .appleStandTime)!
		let startDate = Calendar.current.startOfDay(for: Date())
		let endDate = Date()
		
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		let query = HKStatisticsQuery(quantityType: standType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
			guard let result = result, let sum = result.sumQuantity() else { return }
			let standHours = sum.doubleValue(for: HKUnit.hour())
			DispatchQueue.main.async {
				self.standHours = standHours
			}
		}
		healthStore.execute(query)
	}
}
