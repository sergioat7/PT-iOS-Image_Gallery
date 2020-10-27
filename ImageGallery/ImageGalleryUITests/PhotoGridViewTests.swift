//
//  PhotoGridViewTests.swift
//  ImageGalleryUITests
//
//  Created by 2020 Sergio Aragonés on 25/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import XCTest

class PhotoGridViewTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testSearchPhotosRight() throws {
        
        app.launchArguments.append("--uitesting")
        app.launch()
        
        XCTAssert(app.textFields[localized("SEARCH")].title.isEmpty)

        app.textFields[localized("SEARCH")].tap()

        let keyboard = app.keyboards
        keyboard.keys["k"].tap()
        keyboard.keys["i"].tap()
        keyboard.keys["t"].tap()
        keyboard.keys["t"].tap()
        keyboard.keys["e"].tap()
        keyboard.keys["n"].tap()

        app.keyboards.buttons["Search"].tap()
        
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        app.buttons["ic cross white"].tap()
    }
    
    func testSearchPhotosWrong() {
        
        app.launchArguments.append("--uitesting")
        app.launch()
        
        XCTAssert(app.textFields[localized("SEARCH")].title.isEmpty)

        app.textFields[localized("SEARCH")].tap()

        app.keyboards.buttons["Search"].tap()
        
        let errorDialog = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        XCTAssert(errorDialog.exists)
    }
    
    // MARK: - Private functions
    
    private func localized(_ key: String) -> String {
        
        let uiTestBundle = Bundle(for: PhotoGridViewTests.self)
        return NSLocalizedString(key, bundle: uiTestBundle, comment: "")
    }
}
