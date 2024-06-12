//
//  SettingsViewTest.swift
//  SaludioUITests
//
//  Created by Ravishka Dulshan on 2024-06-12.
//

import XCTest
@testable import Saludio

class SettingsViewTest: XCTestCase {
	
	var app: XCUIApplication!
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
	}
	
	override func tearDownWithError() throws {
		app = nil
	}
	
	func testSettingViewUI() throws {
		// Navigate to Settings view
		let tabBar = app.tabBars["Tab Bar"]
		tabBar.buttons["Settings"].tap()
		
		
		let profileImage = app.images["profileSec2"]
		XCTAssertTrue(profileImage.exists)
		
		let nameTextField = app.staticTexts["nameText"]
		XCTAssertTrue(nameTextField.exists)
		
		let ageTextField = app.staticTexts["ageIntText"]
		XCTAssertTrue(ageTextField.exists)
		
		let weightTextField = app.staticTexts["weight (kg)DoubleText"]
		XCTAssertTrue(weightTextField.exists)
		
		let heightTextField = app.staticTexts["height (cm)DoubleText"]
		XCTAssertTrue(heightTextField.exists)
				
		// Check if edit button exists
		let editSaveButton = app.buttons["editSaveButton"]
		XCTAssertTrue(editSaveButton.exists)
		
		// Tap on the edit button to reveal save functionality
		editSaveButton.tap()
	}
}
