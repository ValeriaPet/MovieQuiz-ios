//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by LERÄ on 14.11.23.
//

import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testScreenCast() throws {
        
    }
    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()

        
    }
}
