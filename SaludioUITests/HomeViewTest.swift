//
//  HomeViewTest.swift
//  SaludioUITests
//
//  Created by Ravishka Dulshan on 2024-06-12.
//

import XCTest
@testable import Saludio

class HealthAppUITests: XCTestCase {
	
	var app: XCUIApplication!
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
	}
	
	override func tearDownWithError() throws {
		app = nil
	}
	
	func testHomeViewUI() throws {
		let dateLabel = app.staticTexts.element(matching: .any, identifier: "dateText")
		XCTAssertTrue(dateLabel.waitForExistence(timeout: 5))
		
		let summaryLabel = app.staticTexts.element(matching: .any, identifier: "summaryText")
		XCTAssertTrue(summaryLabel.exists)
		
		let profileImage = app.images["profileImage"]
		XCTAssertTrue(profileImage.exists)
		
		let activityLabel = app.staticTexts.element(matching: .any, identifier: "activityText")
		XCTAssertTrue(activityLabel.exists)
				
	}
	
	
}
