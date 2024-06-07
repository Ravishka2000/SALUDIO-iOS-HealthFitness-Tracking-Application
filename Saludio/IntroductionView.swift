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
			
			Spacer()
			
			Text("Welcome to")
				.font(.system(size: 30))
				.fontWeight(.heavy)
				
			
			Text("Saludio")
				.font(.system(size: 30))
				.fontWeight(.heavy)
				.foregroundColor(Color.orange) +
			Text(" Mobile App")
				.font(.system(size: 30))
				.fontWeight(.heavy)
			
			Text("The Best Day-to-Day Health and ")
				.font(.body)
				.fontWeight(.regular)
				.foregroundColor(Color.gray)
				.padding(.top, 30)
			
			Text("Fitness Tracker")
				.font(.body)
				.fontWeight(.regular)
				.foregroundColor(Color.gray)
				.padding(.bottom, 30.0)
			
			Image("Introduction")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 400.0, height: 400.0)
			
			Spacer()
			
			NavigationLink(destination: OnboardingView(userModel: $userModel)) {
				Text("Get Started")
					.font(.headline)
					.fontWeight(.heavy)
					.padding()
					.frame(maxWidth: .infinity)
					.background(Color.blue)
					.foregroundColor(.white)
					.cornerRadius(10)
			}
			.frame(maxWidth: .infinity)
			.padding()

		}
	}
}

struct IntoductionView_Previews: PreviewProvider {
	static var previews: some View {
		IntroductionView(userModel: .constant(UserModel.preview))
	}
}
