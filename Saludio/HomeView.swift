//
//  HomeView.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-03.
//

import HealthKitUI
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // Summary Card
                VStack(spacing: 20) {
                    ZStack {
                        SummeryRingView(icon: "arrow.up", BG: "C1", WHeight: 50, completionRate: 1.2, ringThickness: 26, colorGradient: Gradient(colors: [Color("C1"), Color("C2")]))
                        SummeryRingView(icon: "arrow.forward", BG: "C1", WHeight: 120, completionRate: 1.2, ringThickness: 26, colorGradient: Gradient(colors: [Color("C1"), Color("C2")]))
                        SummeryRingView(icon: "arrow.forward", BG: "C1", WHeight: 190, completionRate: 1.2, ringThickness: 26, colorGradient: Gradient(colors: [Color("C1"), Color("C2")]))
                        SummeryRingView(icon: "arrow.forward", BG: "C1", WHeight: 260, completionRate: 1.2, ringThickness: 26, colorGradient: Gradient(colors: [Color("C1"), Color("C2")]))
                    }
                    .padding()

                    VStack(spacing: 20) {
                        HStack(alignment: .center, spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Heart Rate")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("132 BPM")
                                    .fontWeight(.bold)
                                    .font(.headline)
                            }

                            Spacer()

                            VStack(alignment: .leading) {
                                Text("Calories Burned")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("2335 kcal")
                                    .fontWeight(.bold)
                                    .font(.headline)
                            }
                        }

                        HStack(alignment: .top, spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Heart Rate")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("132 BPM")
                                    .fontWeight(.bold)
                                    .font(.headline)
                            }

                            Spacer()

                            VStack(alignment: .leading) {
                                Text("Calories Burned")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("2335 kcal")
                                    .fontWeight(.bold)
                                    .font(.headline)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
            }
            .navigationTitle("Saludio")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
