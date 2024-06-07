//
//  SaludioApp.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-02.
//

import SwiftUI
import SwiftData

@main
struct SaludioApp: App {
	var sharedModelContainer: ModelContainer = {
		let schema = Schema([
			UserModel.self,
			HealthInfoModel.self,
		])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
		
		do {
			return try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()
	
	var body: some Scene {
		WindowGroup {
			LaunchScreen()
		}
		.modelContainer(sharedModelContainer)
	}
}
