//
//  HealthInfoModel.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-02.
//

import Foundation
import SwiftData

@Model
final class HealthInfoModel {
	var name: String
	var weight: Double
	var stepGoal: Double
	var waterIntakeGoal: Double
	var activeCaloriesGoal: Double
	var exerciseMinutesGoal: Double
	var standHoursGoal: Double
	
	init(name: String = "", weight: Double = 0.0, stepGoal: Double = 0.0, waterIntakeGoal: Double = 0.0, activeCaloriesGoal: Double = 0.0, exerciseMinutesGoal: Double = 0.0, standHoursGoal: Double = 0.0) {
		self.name = name
		self.weight = weight
		self.stepGoal = stepGoal
		self.waterIntakeGoal = waterIntakeGoal
		self.activeCaloriesGoal = activeCaloriesGoal
		self.exerciseMinutesGoal = exerciseMinutesGoal
		self.standHoursGoal = standHoursGoal
	}
}
