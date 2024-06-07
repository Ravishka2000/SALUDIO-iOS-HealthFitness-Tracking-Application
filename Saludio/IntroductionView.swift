//
//  IntoductionView.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-06.
//

import SwiftUI
import SwiftData

struct IntroductionView: View {
	@Binding var userModel: UserModel
	
	var body: some View {
		VStack {
			Text("Welcome to HealthTracker")
				.font(.largeTitle)
				.padding()
			Text("Track your health data and set goals to stay fit and healthy.")
				.padding()
			NavigationLink(destination: OnboardingView(userModel: $userModel)) {
				Text("Next")
					.font(.headline)
					.padding()
					.background(Color.blue)
					.foregroundColor(.white)
					.cornerRadius(10)
			}
		}
	}
}

struct IntoductionView_Previews: PreviewProvider {
	static var previews: some View {
		IntroductionView(userModel: .constant(UserModel.preview))
	}
}
