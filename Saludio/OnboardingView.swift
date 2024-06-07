//
//  OnboardingView.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-06.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
	@Binding var userModel: UserModel
	@Environment(\.modelContext) private var modelContext
	
	@State private var name: String = ""
	@State private var age: String = ""
	@State private var weight: String = ""
	@State private var height: String = ""
	
	var body: some View {
		VStack {
			Text("Enter Your Details")
				.font(.largeTitle)
				.padding()
			
			TextField("Name", text: $name)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding()
			
			TextField("Age", text: $age)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding()
				.keyboardType(.numberPad)
			
			TextField("Weight (kg)", text: $weight)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding()
				.keyboardType(.decimalPad)
			
			TextField("Height (cm)", text: $height)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding()
				.keyboardType(.decimalPad)
			
			Button(action: saveUserData) {
				Text("Save")
					.font(.headline)
					.padding()
					.background(Color.green)
					.foregroundColor(.white)
					.cornerRadius(10)
			}
		}
		.padding()
	}
	
	private func saveUserData() {
		guard let ageInt = Int(age),
			  let weightDouble = Double(weight),
			  let heightDouble = Double(height) else {
			return
		}
		
		userModel.name = name
		userModel.age = ageInt
		userModel.weight = weightDouble
		userModel.height = heightDouble
		userModel.isFirstLaunch = false
		
		modelContext.insert(userModel)
		try? modelContext.save() // Ensure to save context
		
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			if let window = windowScene.windows.first {
				window.rootViewController = UIHostingController(rootView: ContentView())
				window.makeKeyAndVisible()
			}
		}
	}
}

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView(userModel: .constant(UserModel.preview))
			.environment(\.modelContext, ModelContext(previewUserContainer))
	}
	
	static var previewUserContainer: ModelContainer = {
		let schema = Schema([UserModel.self])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
		return try! ModelContainer(for: schema, configurations: [modelConfiguration])
	}()
}
