//
//  HomeView.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-03.
//

import HealthKitUI
import SwiftUI

struct HomeView: View {
    @ObservedObject var healthKitManager = HealthKitManager()

    @State private var steps: Double = 0.0
    @State private var mindfulnessMinutes: Double = 0.0
    @State private var waterIntake: Double = 0.0
    @State private var activeCalories: Double = 0.0
    @State private var exerciseMinutes: Double = 0.0
    @State private var standHours: Double = 0.0

    @State private var showTitle: Bool = false

    private var formattedDate: String = {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: today)
    }()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("\(formattedDate)")
                        Text("Summary")
                            .font(.largeTitle)
                            .bold()
                    }
                    .padding()

                    Spacer()

                    Image("Profile")
                        .resizable()
                        .frame(width: 60.0, height: 60.0)
                        .clipShape(Circle())
                        .padding()
                }

                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Activity")
                            .font(.title)
                            .bold()
                            .padding()

                        // Summary Card
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                VStack(alignment: .leading, spacing: -5) {
                                    Text("Steps")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                    Text(String(format: "%.1f", steps))
                                        .fontWeight(.bold)
                                        .font(.title2)
                                        .foregroundColor(Color("steps"))
                                }

                                VStack(alignment: .leading, spacing: -5) {
                                    Text("Calories")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                    Text(String(format: "%.1f", activeCalories))
                                        .fontWeight(.bold)
                                        .font(.title2)
                                        .foregroundColor(Color("calories"))
                                }
                                VStack(alignment: .leading, spacing: -5) {
                                    Text("Exercise")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                    Text(String(format: "%.1f", exerciseMinutes))
                                        .fontWeight(.bold)
                                        .font(.title2)
                                        .foregroundColor(Color("exercise"))
                                }
                            }

                            Spacer()

                            VStack {
                                ZStack {
                                    SummeryRingView(icon: "arrow.up", BG: "steps", WHeight: 50, completionRate: completedStepPercentage(), ringThickness: 20, colorGradient: Gradient(colors: [Color("steps"), Color("steps")]))
                                    SummeryRingView(icon: "arrow.forward", BG: "calories", WHeight: 100, completionRate: burnedCaloriesPercentage(), ringThickness: 20, colorGradient: Gradient(colors: [Color("calories"), Color("calories")]))
                                    SummeryRingView(icon: "arrow.forward", BG: "exercise", WHeight: 150, completionRate: completedExercisePercentage(), ringThickness: 20, colorGradient: Gradient(colors: [Color("exercise"), Color("exercise")]))
                                }
                                .padding()
                            }
                        }
                        .padding()
						.background(.bg)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)

                        VStack {
                            HStack {
                                Text("Steps")
                                Spacer()
                                Text("Distance")
                            }
                            HStack {
                                Text("Steps")
                                Spacer()
                                Text("Distance")
                            }
                            HStack {
                                Text("Steps")
                                Spacer()
                                Text("Distance")
                            }
                            HStack {
                                Text("Steps")
                                Spacer()
                                Text("Distance")
                            }
                        }
                        .padding()
						.background(.bg)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            healthKitManager.requestAuthorization()
            fetchHealthData()
        }
    }

    func fetchHealthData() {
        steps = healthKitManager.steps
        mindfulnessMinutes = healthKitManager.mindfulnessMinutes
        waterIntake = healthKitManager.waterIntake
        activeCalories = healthKitManager.activeCalories
        exerciseMinutes = healthKitManager.exerciseMinutes
        standHours = healthKitManager.standHours
    }

    func completedStepPercentage() -> Double {
        return (steps / 200)
    }

    func burnedCaloriesPercentage() -> Double {
        return (activeCalories / 200)
    }

    func completedExercisePercentage() -> Double {
        return (exerciseMinutes / 200)
    }

    func completedStandingPercentage() -> Double {
        return (standHours / 200)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
