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
						Text("Summary")
							.font(.largeTitle)
							.bold()
					}
					.padding()
					
					Spacer()
					
					Image("Profile")
						.resizable()
						.frame(width: 60.0, height: 60.0)
						.clipShape(Circle())
						.padding()
				}
				
				ScrollView {
					VStack(alignment: .leading) {
						Text("Activity")
							.font(.title)
							.bold()
							.padding()
						
						// Summary Card
						HStack {
							VStack(alignment: .leading, spacing: 10) {
								VStack(alignment: .leading, spacing: -5) {
									Text("Move")
										.font(.subheadline)
										.foregroundColor(Color.primary)
									Text(String(format: "%.1f", activeCalories))
										.fontWeight(.bold)
										.font(.title2)
										.foregroundColor(Color("calories")) +
									Text("/")
										.fontWeight(.bold)
										.font(.title2)
										.foregroundColor(Color("calories")) +
									Text(String(format: "%.1f", healthInfo.activeCaloriesGoal))
										.fontWeight(.bold)
										.font(.title2)
										.foregroundColor(Color("calories")) +
									Text("CAL")
										.font(.footnote)
										.fontWeight(.bold)
										.foregroundColor(Color("calories"))
								}
								
								VStack(alignment: .leading, spacing: -5) {
									Text("Exercise")
										.font(.subheadline)
										.foregroundColor(Color.primary)
									Text(String(format: "%.1f", exerciseMinutes))
										.fontWeight(.bold)
										.font(.title2)
										.foregroundColor(Color("exercise")) +
									Text("/")
										.fontWeight(.bold)
										.font(.title2)
										.foregroundColor(Color("exercise")) +
									Text(String(format: "%.1f", healthInfo.exerciseMinutesGoal))
										.fontWeight(.bold)
										.font(.title2)
										.foregroundColor(Color("exercise")) +
									Text("MIN")
										.font(.footnote)
										.fontWeight(.bold)
										.foregroundColor(Color("exercise"))
								}
								VStack(alignment: .leading, spacing: -5) {
									Text("Stand")
										.font(.subheadline)
										.foregroundColor(Color.primary)
									Text(String(format: "%.1f", standHours))
										.fontWeight(.bold)
										.font(.title2)
										.foregroundColor(Color("stand")) +
									Text("/")
										.fontWeight(.bold)
										.font(.title2)
										.foregroundColor(Color("stand")) +
									Text(String(format: "%.1f", healthInfo.standHoursGoal))
										.fontWeight(.bold)
										.font(.title2)
										.foregroundColor(Color("stand")) +
									Text("HRS")
										.font(.footnote)
										.fontWeight(.bold)
										.foregroundColor(Color("stand"))
								}
							}
							
							Spacer()
							
							VStack {
								ZStack {
									SummeryRingView(icon: "arrow.up", BG: "stand", WHeight: 50, completionRate: completedStandingPercentage(), ringThickness: 20, colorGradient: Gradient(colors: [Color("stand"), Color("stand")]))
									SummeryRingView(icon: "arrow.forward.to.line", BG: "exercise", WHeight: 100, completionRate: completedExercisePercentage(), ringThickness: 20, colorGradient: Gradient(colors: [Color("exercise"), Color("exercise")]))
									SummeryRingView(icon: "arrow.forward", BG: "calories", WHeight: 150, completionRate: burnedCaloriesPercentage(), ringThickness: 20, colorGradient: Gradient(colors: [Color("calories"), Color("calories")]))
								}
								.padding()
							}
						}
						.padding()
						.background(.bg)
						.cornerRadius(15)
						.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
						.padding(.horizontal)
						
						// New UI elements for additional data
						VStack(alignment: .leading, spacing: 10) {
							Group {
								DataRowView(title: "Distance Walking/Running", value: distanceWalkingRunning, unit: "m")
								DataRowView(title: "Walking Pace", value: walkingPace, unit: "m/s")
								DataRowView(title: "Running Pace", value: runningPace, unit: "m/s")
								DataRowView(title: "Resting Energy", value: restingEnergy, unit: "kcal")
								DataRowView(title: "Flights Climbed", value: flightsClimbed, unit: "floors")
								DataRowView(title: "Walking Steadiness", value: walkingSteadiness, unit: "%")
								DataRowView(title: "Walking Speed", value: walkingSpeed, unit: "m/s")
								DataRowView(title: "Walking Step Length", value: walkingStepLength, unit: "m")
								DataRowView(title: "Heart Rate", value: heartRate, unit: "bpm")
								DataRowView(title: "Mindfulness Minutes", value: mindfulnessMinutes, unit: "min")
								DataRowView(title: "Water Intake", value: waterIntake, unit: "ml")
								DataRowView(title: "Stand Hours", value: standHours, unit: "hrs")
							}
						}
						.padding()
						.background(.bg)
						.cornerRadius(15)
						.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
						.padding(.horizontal)
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
		return (steps / 200)
	}
	
	func burnedCaloriesPercentage() -> Double {
		return (activeCalories / 200)
	}
	
	func completedExercisePercentage() -> Double {
		return (exerciseMinutes / 200)
	}
	
	func completedStandingPercentage() -> Double {
		return (standHours / 200)
	}
}

struct DataRowView: View {
	var title: String
	var value: Double
	var unit: String
	
	var body: some View {
		HStack {
			Text(title)
				.font(.subheadline)
				.foregroundColor(Color.gray)
			Spacer()
			Text(String(format: "%.1f", value) + " " + unit)
				.fontWeight(.bold)
				.font(.title2)
				.foregroundColor(Color.primary)
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
