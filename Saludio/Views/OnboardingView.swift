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
	@State private var age: Int = 18
	@State private var weight: Double = 0.0
	@State private var height: Double = 0.0
	
	@State private var isAgePickerVisible: Bool = false
	@State private var showAlert: Bool = false
	@State private var alertMessage: String = ""
	
	var body: some View {
		ScrollView {
			VStack {
				ZStack {
					Color.onboard
						.ignoresSafeArea()
					
					Image("Onboarding3")
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(height: 180)
				}
				.cornerRadius(25)
				
				Text("Enter Your Details")
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding()
				
				VStack(alignment: .leading, spacing: 20) {
					Group {
						Label("Name", systemImage: "person.fill")
							.font(.headline)
						TextField("Enter your name", text: $name)
							.padding()
							.background(Color(UIColor.secondarySystemBackground))
							.cornerRadius(10)
						
						Label("Age", systemImage: "calendar")
							.font(.headline)
						HStack {
							Text("\(age) years")
								.foregroundColor(.primary)
							Spacer()
							Button(action: {
								isAgePickerVisible.toggle()
							}) {
								Image(systemName: "chevron.down")
									.foregroundColor(.gray)
							}
						}
						.padding()
						.background(Color(UIColor.secondarySystemBackground))
						.cornerRadius(10)
						
						if isAgePickerVisible {
							Picker("Select your age", selection: $age) {
								ForEach(10..<100) {
									Text("\($0) years").tag($0)
								}
							}
							.pickerStyle(WheelPickerStyle())
							.frame(height: 150)
							.clipped()
							.background(Color(UIColor.secondarySystemBackground))
							.cornerRadius(20)
							.padding()
							.transition(.opacity)
						}
						
						Label("Weight (kg)", systemImage: "scalemass")
							.font(.headline)
						HStack {
							TextField("Enter your weight", value: $weight, formatter: decimalFormatter)
								.padding()
								.background(Color(UIColor.secondarySystemBackground))
								.cornerRadius(10)
								.keyboardType(.decimalPad)
							Spacer()
							Stepper("", value: $weight, in: 30...200, step: 0.5)
						}
						
						Label("Height (cm)", systemImage: "ruler.fill")
							.font(.headline)
						HStack {
							TextField("Enter your height", value: $height, formatter: decimalFormatter)
								.padding()
								.background(Color(UIColor.secondarySystemBackground))
								.cornerRadius(10)
								.keyboardType(.decimalPad)
							Spacer()
							Stepper("", value: $height, in: 80...250, step: 0.5)
						}
					}
				}
				.padding(.horizontal)
				
				Spacer()
				
				Button(action: saveUserData) {
					Text("Save")
						.font(.headline)
						.padding()
						.frame(maxWidth: .infinity)
						.background(Color.green)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.padding()
			}
			.padding()
		}
		.background(Color(UIColor.systemBackground))
		.foregroundColor(Color(UIColor.label))
		.alert(isPresented: $showAlert) {
			Alert(title: Text("Save Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
		}
	}
	
	private func saveUserData() {
		userModel.name = name
		userModel.age = age
		userModel.weight = weight
		userModel.height = height
		userModel.isFirstLaunch = false
		
		do {
			modelContext.insert(userModel)
			try modelContext.save()
			alertMessage = "Data saved successfully!"
			if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
				if let window = windowScene.windows.first {
					window.rootViewController = UIHostingController(rootView: ContentView())
					window.makeKeyAndVisible()
				}
			}
		} catch {
			alertMessage = "Failed to save data: \(error.localizedDescription)"
		}
		
		showAlert = true
	}
	
	private var decimalFormatter: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 1
		return formatter
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
