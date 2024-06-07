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
				VStack {
					Spacer()
					
					VStack {
						HStack (alignment: .center, spacing: 20.0) {
							Image("Logo")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 100.0, height: 100.0)
							
							Text("SALUDIO")
								.font(.system(size: 50))
								.fontWeight(.heavy)
						}
					}
					.padding(.top, 50.0)
					
					Spacer()
					
					Text("Your Health Companion")
						.font(.title)
						.fontWeight(.bold)
						.multilineTextAlignment(.center)
						.padding(.bottom, 40)
				}
				.edgesIgnoringSafeArea(.all)
				.onAppear {
					DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
