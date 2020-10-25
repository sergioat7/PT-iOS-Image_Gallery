//
//  PhotoGridViewModelTests.swift
//  ImageGalleryTests
//
//  Created by Sergio Aragonés on 25/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import XCTest
@testable import ImageGallery

class PhotoGridViewModelTests: XCTestCase {
    
    var sut: PhotoGridViewModelProtocol!
    var view: PhotoGridViewController!

    override func setUpWithError() throws {
        
        super.setUp()
        let dataManager = PhotoGridDataManager(apiClient: PhotoGridApiClient())
        if let vc = UIStoryboard(name: "PhotoGridView", bundle: nil).instantiateViewController(withIdentifier: "PhotoGrid") as? PhotoGridViewController {
            view = vc
        } else {
            view = PhotoGridViewController()
        }
        sut = PhotoGridViewModel(view: view,
                                 dataManager: dataManager)
    }

    override func tearDownWithError() throws {
        
        sut = nil
        view = nil
        super.tearDown()
    }
    
    func testReloadDataRight() throws {
        
        sut.reloadData()
        XCTAssertTrue(sut.getPhotoCellViewModels().count == 0)
    }
}
