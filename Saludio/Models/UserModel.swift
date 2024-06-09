//
//  UserModel.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-06.
//

import Foundation
import SwiftData

@Model
final class UserModel {
	var name: String
	var age: Int
	var weight: Double
	var height: Double
	var isFirstLaunch: Bool
	
	init(name: String = "", age: Int = 0, weight: Double = 0.0, height: Double = 0.0, isFirstLaunch: Bool = true) {
		self.name = name
		self.age = age
		self.weight = weight
		self.height = height
		self.isFirstLaunch = isFirstLaunch
	}
	
}

extension UserModel {
	static var preview: UserModel {
		return UserModel(name: "John Doe", age: 30, weight: 70.0, height: 175.0, isFirstLaunch: true)
	}
}
