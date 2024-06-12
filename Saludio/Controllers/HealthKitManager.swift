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
	@Published var distanceWalkingRunning: Double = 0.0
	@Published var walkingPace: Double = 0.0
	@Published var runningPace: Double = 0.0
	@Published var restingEnergy: Double = 0.0
	@Published var flightsClimbed: Double = 0.0
	@Published var walkingSteadiness: Double = 0.0
	@Published var walkingSpeed: Double = 0.0
	@Published var walkingStepLength: Double = 0.0
	@Published var sleepAnalysis: [HKCategorySample] = []
	@Published var heartRate: Double = 0.0
	@Published var weeklySteps: [Double] = Array(repeating: 0.0, count: 7)
	@Published var weeklyWaterIntake: [Double] = Array(repeating: 0.0, count: 7)
	@Published var weeklyExerciseMinutes: [Double] = Array(repeating: 0.0, count: 7)
	@Published var weeklyStandHours: [Double] = Array(repeating: 0.0, count: 7)
	@Published var weeklyActiveCalories: [Double] = Array(repeating: 0.0, count: 7)
	
	init(healthStore: HKHealthStore = HKHealthStore()) {
		self.healthStore = healthStore
	}
	
	func requestAuthorization() {
		let readTypes = Set([
			HKQuantityType.quantityType(forIdentifier: .stepCount)!,
			HKCategoryType.categoryType(forIdentifier: .mindfulSession)!,
			HKQuantityType.quantityType(forIdentifier: .dietaryWater)!,
			HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
			HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!,
			HKQuantityType.quantityType(forIdentifier: .appleStandTime)!,
			HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
			HKQuantityType.quantityType(forIdentifier: .walkingSpeed)!,
			HKQuantityType.quantityType(forIdentifier: .walkingStepLength)!,
			HKQuantityType.quantityType(forIdentifier: .appleWalkingSteadiness)!,
			HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!,
			HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
			HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!,
			HKQuantityType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
			HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
		])
		
		healthStore.requestAuthorization(toShare: [], read: readTypes) { (success, error) in
			if success {
				self.fetchWeeklyStepCounts()
				self.fetchWeeklyWaterIntake()
				self.fetchWeeklyExerciseMinutes()
				self.fetchWeeklyStandHours()
				self.fetchWeeklyActiveCalories()
				self.fetchData(for: .stepCount)
				self.fetchData(for: .mindfulSession)
				self.fetchData(for: .dietaryWater)
				self.fetchData(for: .activeEnergyBurned)
				self.fetchData(for: .appleExerciseTime)
				self.fetchData(for: .appleStandTime)
				self.fetchData(for: .distanceWalkingRunning)
				self.fetchData(for: .walkingSpeed)
				self.fetchData(for: .walkingStepLength)
				self.fetchData(for: .appleWalkingSteadiness)
				self.fetchData(for: .flightsClimbed)
				self.fetchData(for: .basalEnergyBurned)
				self.fetchData(for: .restingHeartRate)
				self.fetchData(for: .sleepAnalysis)
				self.fetchData(for: .heartRate)
			}
		}
	}
	
	func fetchData(for identifier: HKQuantityTypeIdentifier) {
		guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
		
		let startDate = Calendar.current.startOfDay(for: Date())
		let endDate = Date()
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		
		var options: HKStatisticsOptions = .cumulativeSum
		switch identifier {
		case .walkingSpeed, .walkingStepLength, .appleWalkingSteadiness, .restingHeartRate, .heartRate, .walkingHeartRateAverage:
			options = .discreteAverage
		default:
			options = .cumulativeSum
		}
		
		let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: options) { (query, result, error) in
			guard let result = result else { return }
			DispatchQueue.main.async {
				switch identifier {
				case .stepCount:
					self.steps = result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
				case .dietaryWater:
					self.waterIntake = result.sumQuantity()?.doubleValue(for: HKUnit.literUnit(with: .milli)) ?? 0.0
				case .activeEnergyBurned:
					self.activeCalories = result.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0.0
				case .appleExerciseTime:
					self.exerciseMinutes = result.sumQuantity()?.doubleValue(for: HKUnit.minute()) ?? 0.0
				case .appleStandTime:
					self.standHours = result.sumQuantity()?.doubleValue(for: HKUnit.hour()) ?? 0.0
				case .distanceWalkingRunning:
					self.distanceWalkingRunning = result.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0.0
				case .walkingSpeed:
					self.walkingPace = result.averageQuantity()?.doubleValue(for: HKUnit.meter().unitDivided(by: HKUnit.second())) ?? 0.0
				case .walkingStepLength:
					self.walkingStepLength = result.averageQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0.0
				case .appleWalkingSteadiness:
					self.walkingSteadiness = result.averageQuantity()?.doubleValue(for: HKUnit.percent()) ?? 0.0
				case .flightsClimbed:
					self.flightsClimbed = result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
				case .basalEnergyBurned:
					self.restingEnergy = result.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0.0
				case .restingHeartRate, .walkingHeartRateAverage, .heartRate:
					self.heartRate = result.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0.0
				default:
					break
				}
			}
		}
		healthStore.execute(query)
	}
	
	func fetchData(for identifier: HKCategoryTypeIdentifier) {
		guard let categoryType = HKCategoryType.categoryType(forIdentifier: identifier) else { return }
		
		let startDate = Calendar.current.startOfDay(for: Date())
		let endDate = Date()
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		
		let query = HKSampleQuery(sampleType: categoryType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
			guard let samples = samples as? [HKCategorySample] else { return }
			DispatchQueue.main.async {
				switch identifier {
				case .mindfulSession:
					self.mindfulnessMinutes = samples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) / 60 }
				case .sleepAnalysis:
					self.sleepAnalysis = samples
				default:
					break
				}
			}
		}
		healthStore.execute(query)
	}
	
	func fetchWeeklyStepCounts() {
		fetchWeeklyData(for: .stepCount, unit: HKUnit.count(), updateHandler: { self.weeklySteps = $0 })
	}
	
	func fetchWeeklyWaterIntake() {
		fetchWeeklyData(for: .dietaryWater, unit: HKUnit.literUnit(with: .milli), updateHandler: { self.weeklyWaterIntake = $0 })
	}
	
	func fetchWeeklyExerciseMinutes() {
		fetchWeeklyData(for: .appleExerciseTime, unit: HKUnit.minute(), updateHandler: { self.weeklyExerciseMinutes = $0 })
	}
	
	func fetchWeeklyStandHours() {
		fetchWeeklyData(for: .appleStandTime, unit: HKUnit.hour(), updateHandler: { self.weeklyStandHours = $0 })
	}
	
	func fetchWeeklyActiveCalories() {
		fetchWeeklyData(for: .activeEnergyBurned, unit: HKUnit.kilocalorie(), updateHandler: { self.weeklyActiveCalories = $0 })
	}

	private func fetchWeeklyData(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, updateHandler: @escaping ([Double]) -> Void) {
		guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
			print("Failed to create quantity type for identifier: \(identifier)")
			return
		}
		
		var dailyValues: [Double] = Array(repeating: 0.0, count: 7)
		let calendar = Calendar.current
		
		let now = Date()
		guard let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) else {
			print("Failed to calculate start date")
			return
		}
		let endDate = now
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		
		let interval = DateComponents(day: 1)
		let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: interval)
		
		query.initialResultsHandler = { query, results, error in
			if error != nil {
				return
			}
			guard let results = results else {
				return
			}
			results.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
				let date = statistics.startDate
				let dayIndex = calendar.component(.weekday, from: date) - 1
				let value = statistics.sumQuantity()?.doubleValue(for: unit) ?? 0.0
				dailyValues[dayIndex] = value
			}
			DispatchQueue.main.async {
				updateHandler(dailyValues)
			}
		}
		
		healthStore.execute(query)
	}

}
