//
//  SettingsView.swift
//  Saludio
//
//  Created by Ravishka Dulshan on 2024-06-03.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userInfoList: [UserModel]
    @State private var userInfo = UserModel()
    @State private var isEditing = false
    @State private var showSaveAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""

    private func loadExistingData() {
        if let existingUserInfo = userInfoList.first {
            userInfo = existingUserInfo
        }
    }

    var body: some View {
        NavigationView {
            VStack {
				ZStack {
					Rectangle()
						.frame(height: 220.0)
						.foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.green.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
						.cornerRadius(20)
					
					Image("profileSec2")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: .infinity, maxHeight: 200)
						.clipped()
				}
				.padding()

                Form {
                    Section(header: Text("Personal Information")
                        .font(.headline)
                        .padding(.top, 10)
                        .foregroundColor(.secondary)) {
                            CustomTextField(label: "Name", text: $userInfo.name, isEditing: $isEditing)
                            CustomIntField(label: "Age", value: $userInfo.age, isEditing: $isEditing)
                            CustomDoubleField(label: "Weight (kg)", value: $userInfo.weight, isEditing: $isEditing)
                            CustomDoubleField(label: "Height (cm)", value: $userInfo.height, isEditing: $isEditing)
                        }

                    Section {
                        Button(action: toggleEditMode) {
                            Text(isEditing ? "Save" : "Edit")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isEditing ? Color.green : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.vertical, 5)
                        }
                        .animation(.easeInOut, value: isEditing)
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear(perform: loadExistingData)
            .alert(isPresented: $showSaveAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func toggleEditMode() {
        if isEditing {
            saveChanges()
        }
        isEditing.toggle()
    }

    private func saveChanges() {
        do {
            if userInfoList.isEmpty {
                modelContext.insert(userInfo)
            } else {
                if let existingUserInfo = userInfoList.first {
                    existingUserInfo.name = userInfo.name
                    existingUserInfo.age = userInfo.age
                    existingUserInfo.weight = userInfo.weight
                    existingUserInfo.height = userInfo.height
                }
            }
            try modelContext.save()
            alertTitle = "Success"
            alertMessage = "User data saved successfully!"
        } catch {
            alertTitle = "Error"
            alertMessage = "Failed to save user data: \(error.localizedDescription)"
        }
        showSaveAlert = true
    }
}

struct CustomTextField: View {
    let label: String
    @Binding var text: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.primary)
            Spacer()
            if isEditing {
                TextField("Enter your \(label.lowercased())", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibility(label: Text(label))
            } else {
                Text(text)
                    .accessibility(label: Text(label))
            }
        }
        .padding(.vertical, 5)
    }
}

struct CustomIntField: View {
    let label: String
    @Binding var value: Int
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.primary)
            Spacer()
            if isEditing {
                TextField("Enter your \(label.lowercased())", value: $value, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibility(label: Text(label))
            } else {
                Text("\(value)")
                    .accessibility(label: Text(label))
            }
        }
        .padding(.vertical, 5)
    }
}

struct CustomDoubleField: View {
    let label: String
    @Binding var value: Double
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.primary)
            Spacer()
            if isEditing {
                TextField("Enter your \(label.lowercased())", value: $value, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibility(label: Text(label))
            } else {
                Text("\(value, specifier: "%.1f")")
                    .accessibility(label: Text(label))
            }
        }
        .padding(.vertical, 5)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .modelContainer(for: UserModel.self, inMemory: true)
    }
}
