//
//  LaunchScreen.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-06.
//

import SwiftUI
import SwiftData

struct LaunchScreen: View {
	@State private var isActive = false
	@Environment(\.modelContext) private var modelContext
	@Query private var userInfoList: [UserModel]
	@State private var userModel = UserModel()
	
	private func loadExistingData() {
		if let existingUserInfo = userInfoList.first {
			userModel = existingUserInfo
		}
	}
	
	var body: some View {
		Group {
			if isActive {
				if userModel.isFirstLaunch {
					NavigationView {
						IntroductionView(userModel: $userModel)
					}
				} else {
					ContentView()
				}
			} else {
				ZStack {
					LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.green.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
						.edgesIgnoringSafeArea(.all)
					
					VStack {
						Spacer()
						
						VStack(spacing: 20) {
							Image("Logo")
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: 150, height: 150)
															
							Text("SALUDIO")
								.font(.system(size: 40))
								.fontWeight(.heavy)
								.foregroundColor(.primary)
								.opacity(0.4)
								.accessibilityIdentifier("saludio")
						}
						.padding(.top, 60)
						
						Spacer()
						
						Text("Wellness Simplified")
							.font(.title2)
							.fontWeight(.medium)
							.foregroundColor(.primary)
							.padding(.bottom, 50)
							.opacity(0.5)
					}
				}
				.onAppear {
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						withAnimation {
							loadExistingData()
							self.isActive = true
						}
					}
				}
			}
		}
	}
}

struct LaunchScreen_Previews: PreviewProvider {
	static var previews: some View {
		LaunchScreen()
			.environment(\.modelContext, ModelContext(previewUserContainer))
	}
	
	static var previewUserContainer: ModelContainer = {
		let schema = Schema([UserModel.self])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
		return try! ModelContainer(for: schema, configurations: [modelConfiguration])
	}()
}
