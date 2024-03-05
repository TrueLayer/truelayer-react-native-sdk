//
//  DemoAppUITests.swift
//  DemoAppUITests
//
//  Created by Lukasz Franieczek on 28/11/2023.
//

import XCTest

final class DemoAppUITests: XCTestCase {
  let timeout: TimeInterval = 30
  
  override func setUpWithError() throws {
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
  }
  
  func testProvidersListRenders() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()
    
    let startSDKButton = app.otherElements["Start SDK"]
    XCTAssert(startSDKButton.waitForExistence(timeout: timeout), "startSDKButton does not exist.")
    XCTAssert(startSDKButton.isHittable, "startSDKButton is not hittable.")
    
    startSDKButton.tap()
    
    let processSinglePaymentButton = app.otherElements["Process Single Payment GBP"]
    XCTAssert(processSinglePaymentButton.waitForExistence(timeout: timeout), "processSinglePaymentButton does not exist.")
    XCTAssert(processSinglePaymentButton.isHittable, "processSinglePaymentButton is not hittable.")
    
    processSinglePaymentButton.tap()
    
    let providersTitle = app.staticTexts["Choose your bank"]
    
    XCTAssert(providersTitle.waitForExistence(timeout: timeout), "providersTitle does not exist.")
    XCTAssertTrue(providersTitle.isHittable, "providersTitle is not hittable.")
  }
}
