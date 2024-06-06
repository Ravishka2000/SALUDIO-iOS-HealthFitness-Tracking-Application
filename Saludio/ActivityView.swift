//
//  ActivityView.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-03.
//

import SwiftUI
import SwiftData

struct ActivityView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var healthInfoList: [HealthInfoModel]
	@State private var healthInfo = HealthInfoModel()
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 40) {
					VStack(spacing: 20) {
						Image(systemName: "heart.circle.fill")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 100, height: 100)
							.foregroundColor(.red)
						
						Text("Health Goals")
							.font(.title)
							.fontWeight(.bold)
							.foregroundColor(.primary)
					}
					
					VStack(spacing: 30) {
						goalInputView(title: "Daily Step Goal", value: $healthInfo.stepGoal)
						goalInputView(title: "Water Intake Goal(L)", value: $healthInfo.waterIntakeGoal)
						goalInputView(title: "Active Calories Goal", value: $healthInfo.activeCaloriesGoal)
						goalInputView(title: "Exercise time Goal", value: $healthInfo.exerciseMinutesGoal)
						goalInputView(title: "Stand Hours Goal", value: $healthInfo.standHoursGoal)
					}
					
					Button(action: saveGoals) {
						Text("Save Goals")
							.foregroundColor(.white)
							.fontWeight(.bold)
							.padding(.vertical)
							.frame(maxWidth: .infinity)
							.background(Color.blue)
							.cornerRadius(10)
					}
				}
				.onAppear {
					loadExistingData()
				}
			}
			.navigationBarTitle("Set Your Goals", displayMode: .large)
			.padding()
		}
	}
	
	private var numberFormatter: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}
	
	private func goalInputView(title: String, value: Binding<Double>) -> some View {
		HStack {
			Text(title)
				.font(.headline)
				.frame(minWidth: 170, alignment: .leading)
			
			Spacer()
			
			TextField("", value: value, formatter: numberFormatter)
				.padding(.horizontal)
				.padding(.vertical, 4)
				.frame(width: 80)
				.background(Color(.systemGray6))
				.cornerRadius(8)
			
			Stepper("", onIncrement: {
				value.wrappedValue += 1
			}, onDecrement: {
				value.wrappedValue -= 1
			})
		}
	}
	
	private func loadExistingData() {
		if let existingHealthInfo = healthInfoList.first {
			healthInfo = existingHealthInfo
		}
	}
	
	private func saveGoals() {
		do {
			if healthInfoList.isEmpty {
				modelContext.insert(healthInfo)
			}
			try modelContext.save()
		} catch {
			print("Failed to save goals: \(error)")
		}
	}
}

struct ActivityView_Previews: PreviewProvider {
	static var previews: some View {
		ActivityView()
			.modelContainer(for: HealthInfoModel.self, inMemory: true)
	}
}
