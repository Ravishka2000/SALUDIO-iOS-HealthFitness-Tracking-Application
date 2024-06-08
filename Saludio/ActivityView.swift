//
//  ActivityView.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-03.
//

import SwiftData
import SwiftUI

struct ActivityView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var healthInfoList: [HealthInfoModel]
	@State private var healthInfo = HealthInfoModel()
	@State private var showSaveAlert = false
	@State private var alertMessage = ""
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 30) {
					Image("ActivityImage")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: .infinity, maxHeight: 200)
						.clipped()
						.cornerRadius(12)
					
					VStack(spacing: 20) {
						goalInputView(title: "Daily Step Goal", value: $healthInfo.stepGoal, systemImage: "figure.walk", iconColor: .orange)
						goalInputView(title: "Water Intake Goal (L)", value: $healthInfo.waterIntakeGoal, systemImage: "drop.fill", iconColor: .blue)
						goalInputView(title: "Active Calories Goal", value: $healthInfo.activeCaloriesGoal, systemImage: "flame.fill", iconColor: .red)
						goalInputView(title: "Exercise Time Goal", value: $healthInfo.exerciseMinutesGoal, systemImage: "dumbbell.fill", iconColor: .green)
						goalInputView(title: "Stand Hours Goal", value: $healthInfo.standHoursGoal, systemImage: "figure.stand", iconColor: .cyan)
					}
					
					Button(action: saveGoals) {
						Text("Save Goals")
							.font(.headline)
							.foregroundColor(.white)
							.padding()
							.frame(maxWidth: .infinity)
							.background(Color.green)
							.cornerRadius(10)
					}
				}
				.padding(.vertical)
				.onAppear {
					loadExistingData()
				}
			}
			.navigationBarTitle("Set Your Goals", displayMode: .large)
			.padding(.horizontal)
			.alert(isPresented: $showSaveAlert) {
				Alert(title: Text("Save Goals"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
			}
		}
	}
	
	private var numberFormatter: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}
	
	private func goalInputView(title: String, value: Binding<Double>, systemImage: String, iconColor: Color) -> some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: systemImage)
					.foregroundColor(iconColor)
				Text(title)
					.font(.headline)
			}
			
			HStack {
				TextField("", value: nonNegativeBinding(for: value), formatter: numberFormatter)
					.padding(.horizontal)
					.padding(.vertical, 4)
					.frame(minWidth: 50)
					.background(Color(.systemGray6))
					.cornerRadius(8)
				
				Stepper("", onIncrement: {
					value.wrappedValue += 1
				}, onDecrement: {
					if value.wrappedValue > 0 {
						value.wrappedValue -= 1
					}
				})
				.labelsHidden()
			}
		}
		.padding()
		.background(Color(.systemGray5))
		.cornerRadius(10)
	}
	
	private func nonNegativeBinding(for value: Binding<Double>) -> Binding<Double> {
		return Binding(
			get: { max(0, value.wrappedValue) },
			set: { newValue in
				value.wrappedValue = max(0, newValue)
			}
		)
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
			alertMessage = "Goals saved successfully!"
		} catch {
			alertMessage = "Failed to save goals: \(error.localizedDescription)"
		}
		showSaveAlert = true
	}
}

struct ActivityView_Previews: PreviewProvider {
	static var previews: some View {
		ActivityView()
			.modelContainer(for: HealthInfoModel.self, inMemory: true)
	}
}
