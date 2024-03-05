//
//  DemoAppUITests.swift
//  DemoAppUITests
//
//  Created by Lukasz Franieczek on 28/11/2023.
//

import XCTest

final class DemoAppUITests: XCTestCase {

    override func setUpWithError() throws {
      // In UI tests it is usually best to stop immediately when a failure occurs.
      continueAfterFailure = false
    }

    func testProvidersListRenders() throws {
      // UI tests must launch the application that they test.
      let app = XCUIApplication()
      app.launch()

      let startSDKPredicate = NSPredicate(format: "label CONTAINS[c] 'Start SDK'")
      let startSDKButton = app.staticTexts.matching(startSDKPredicate).firstMatch
      let processSinglePaymentPredicate = NSPredicate(format: "label CONTAINS[c] 'Process Single Payment'")
      let processSinglePaymentButton = app.staticTexts.matching(processSinglePaymentPredicate).firstMatch
      
      
      let _ = startSDKButton.waitForExistence(timeout: TimeInterval(integerLiteral: 30))
      XCTAssertTrue(startSDKButton.isHittable, "startSDKButton is not hittable.")
      XCTAssertTrue(processSinglePaymentButton.isHittable, "processSinglePaymentButton is not hittable.")
      
      startSDKButton.tap()
      processSinglePaymentButton.tap()
    
      let providersTitle = app.staticTexts["Choose your bank"]
      
      let _ = providersTitle.waitForExistence(timeout: TimeInterval(integerLiteral: 30))
      XCTAssertTrue(providersTitle.isHittable, "providersTitle is not hittable.")
    }
}
