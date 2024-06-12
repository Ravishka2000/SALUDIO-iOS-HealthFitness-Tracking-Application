//
//  HomeView.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-03.
//

import HealthKitUI
import SwiftUI
import SwiftData

struct HomeView: View {
	@ObservedObject var healthKitManager = HealthKitManager()
	@Environment(\.modelContext) private var modelContext
	@Query private var healthInfoList: [HealthInfoModel]
	@State private var healthInfo = HealthInfoModel()
	
	@State private var steps: Double = 0.0
	@State private var mindfulnessMinutes: Double = 0.0
	@State private var waterIntake: Double = 0.0
	@State private var activeCalories: Double = 0.0
	@State private var exerciseMinutes: Double = 0.0
	@State private var standHours: Double = 0.0
	@State private var distanceWalkingRunning: Double = 0.0
	@State private var walkingPace: Double = 0.0
	@State private var runningPace: Double = 0.0
	@State private var restingEnergy: Double = 0.0
	@State private var flightsClimbed: Double = 0.0
	@State private var walkingSteadiness: Double = 0.0
	@State private var walkingSpeed: Double = 0.0
	@State private var walkingStepLength: Double = 0.0
	@State private var sleepAnalysis: [HKCategorySample] = []
	@State private var heartRate: Double = 0.0
	
	@State private var showTitle: Bool = false
	
	private var formattedDate: String = {
		let today = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .full
		return dateFormatter.string(from: today)
	}()
	
	private func loadExistingData() {
		if let existingHealthInfo = healthInfoList.first {
			healthInfo = existingHealthInfo
		}
	}
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				HStack(alignment: .center) {
					VStack(alignment: .leading) {
						Text("\(formattedDate)")
							.accessibilityIdentifier("dateText")
						Text("Summary")
							.font(.largeTitle)
							.bold()
							.accessibilityIdentifier("summaryText")
					}
					.padding()
					
					Spacer()
					
					Image("Profile")
						.resizable()
						.frame(width: 60.0, height: 60.0)
						.clipShape(Circle())
						.padding()
						.accessibilityIdentifier("profileImage")
				}
				
				ScrollView {
					VStack(alignment: .leading, spacing: 20) {
						Text("Activity")
							.font(.title)
							.bold()
							.padding()
							.accessibilityIdentifier("activityText")
						
						// Summary view
						HStack {
							VStack(alignment: .leading, spacing: 10) {
								MetricView(title: "Move", value: activeCalories, goal: healthInfo.activeCaloriesGoal, unit: "CAL", color: Color("calories"))
									.accessibilityIdentifier("moveMetric")
								MetricView(title: "Exercise", value: exerciseMinutes, goal: healthInfo.exerciseMinutesGoal, unit: "MIN", color: Color("exercise"))
									.accessibilityIdentifier("exerciseMetric")
								MetricView(title: "Stand", value: standHours, goal: healthInfo.standHoursGoal, unit: "HRS", color: Color("stand"))
									.accessibilityIdentifier("standMetric")
							}
							
							Spacer()
							
							VStack {
								ZStack {
									SummeryRingView(icon: "arrow.up", BG: "stand", WHeight: 50, completionRate: completedStandingPercentage(), ringThickness: 20, colorGradient: Gradient(colors: [Color("stand"), Color("stand")]))
										.accessibilityIdentifier("standRingView")
									SummeryRingView(icon: "arrow.forward.to.line", BG: "exercise", WHeight: 100, completionRate: completedExercisePercentage(), ringThickness: 20, colorGradient: Gradient(colors: [Color("exercise"), Color("exercise")]))
										.accessibilityIdentifier("exerciseRingView")
									SummeryRingView(icon: "arrow.forward", BG: "calories", WHeight: 150, completionRate: burnedCaloriesPercentage(), ringThickness: 20, colorGradient: Gradient(colors: [Color("calories"), Color("calories")]))
										.accessibilityIdentifier("caloriesRingView")
								}
								.padding()
							}
						}
						.padding()
						.background(Color("bg"))
						.cornerRadius(15)
						.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
						.padding(.horizontal)
						
						VStack(alignment: .leading, spacing: 10) {
							ForEach(healthMetrics, id: \.title) { metric in
								HealthMetricCard(metric: metric)
									.accessibilityIdentifier("metricCard_\(metric.title.replacingOccurrences(of: " ", with: "_"))")
							}
						}
						.padding()
					}
				}
			}
		}
		.onAppear {
			healthKitManager.requestAuthorization()
			loadExistingData()
		}
		.onChange(of: healthKitManager.steps) { steps = healthKitManager.steps }
		.onChange(of: healthKitManager.mindfulnessMinutes) { mindfulnessMinutes = healthKitManager.mindfulnessMinutes }
		.onChange(of: healthKitManager.waterIntake) { waterIntake = healthKitManager.waterIntake }
		.onChange(of: healthKitManager.activeCalories) { activeCalories = healthKitManager.activeCalories }
		.onChange(of: healthKitManager.exerciseMinutes) { exerciseMinutes = healthKitManager.exerciseMinutes }
		.onChange(of: healthKitManager.standHours) { standHours = healthKitManager.standHours }
		.onChange(of: healthKitManager.distanceWalkingRunning) { distanceWalkingRunning = healthKitManager.distanceWalkingRunning }
		.onChange(of: healthKitManager.walkingPace) { walkingPace = healthKitManager.walkingPace }
		.onChange(of: healthKitManager.runningPace) { runningPace = healthKitManager.runningPace }
		.onChange(of: healthKitManager.restingEnergy) { restingEnergy = healthKitManager.restingEnergy }
		.onChange(of: healthKitManager.flightsClimbed) { flightsClimbed = healthKitManager.flightsClimbed }
		.onChange(of: healthKitManager.walkingSteadiness) { walkingSteadiness = healthKitManager.walkingSteadiness }
		.onChange(of: healthKitManager.walkingSpeed) { walkingSpeed = healthKitManager.walkingSpeed }
		.onChange(of: healthKitManager.walkingStepLength) { walkingStepLength = healthKitManager.walkingStepLength }
		.onChange(of: healthKitManager.heartRate) { heartRate = healthKitManager.heartRate }
	}
	
	func completedStepPercentage() -> Double {
		return (steps / healthInfo.stepGoal)
	}
	
	func burnedCaloriesPercentage() -> Double {
		return (activeCalories / healthInfo.activeCaloriesGoal)
	}
	
	func completedExercisePercentage() -> Double {
		return (exerciseMinutes / healthInfo.exerciseMinutesGoal)
	}
	
	func completedStandingPercentage() -> Double {
		return (standHours / healthInfo.standHoursGoal)
	}
	
	private var healthMetrics: [(title: String, value: Double, unit: String, icon: String, color: Color)] {
		return [
			("Distance Walking/Running", distanceWalkingRunning, "m", "figure.walk", Color.purple),
			("Walking Pace", walkingPace, "m/s", "speedometer", Color.green),
			("Running Pace", runningPace, "m/s", "speedometer", Color.red),
			("Resting Energy", restingEnergy, "kcal", "flame", Color.orange),
			("Flights Climbed", flightsClimbed, "floors", "stairs", Color.blue),
			("Walking Steadiness", walkingSteadiness, "%", "heart", Color.pink),
			("Walking Speed", walkingSpeed, "m/s", "speedometer", Color.yellow),
			("Walking Step Length", walkingStepLength, "m", "ruler", Color.cyan),
			("Heart Rate", heartRate, "bpm", "heart.fill", Color.red),
			("Mindfulness Minutes", mindfulnessMinutes, "min", "brain.head.profile", Color.teal),
			("Water Intake", waterIntake, "ml", "drop", Color.blue),
			("Stand Hours", standHours, "hrs", "timer", Color.purple)
		]
	}
}

struct MetricView: View {
	var title: String
	var value: Double
	var goal: Double
	var unit: String
	var color: Color
	
	var body: some View {
		VStack(alignment: .leading, spacing: -5) {
			Text(title)
				.font(.subheadline)
				.foregroundColor(Color.primary)
			Text(String(format: "%.1f", value))
				.fontWeight(.bold)
				.font(.title2)
				.foregroundColor(color) +
			Text("/")
				.fontWeight(.bold)
				.font(.title2)
				.foregroundColor(color) +
			Text(String(format: "%.1f", goal))
				.fontWeight(.bold)
				.font(.title2)
				.foregroundColor(color) +
			Text(unit)
				.font(.footnote)
				.fontWeight(.bold)
				.foregroundColor(color)
		}
	}
}

struct HealthMetricCard: View {
	var metric: (title: String, value: Double, unit: String, icon: String, color: Color)
	
	var body: some View {
		HStack {
			Image(systemName: metric.icon)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 40, height: 40)
				.foregroundColor(metric.color)
				.padding(.trailing, 10)
			VStack(alignment: .leading) {
				Text(metric.title)
					.font(.headline)
					.foregroundColor(Color.primary)
				Text(String(format: "%.1f", metric.value) + " " + metric.unit)
					.fontWeight(.bold)
					.font(.title2)
					.foregroundColor(Color.primary)
			}
			Spacer()
		}
		.padding()
		.background(Color("bg"))
		.cornerRadius(15)
		.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
