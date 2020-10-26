//
//  PhotoGridViewModelTests.swift
//  ImageGalleryTests
//
//  Created by Sergio Aragonés on 25/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import ImageGallery

class PhotoGridViewModelTests: XCTestCase {
    
    var sut: PhotoGridViewModelProtocol!

    override func setUpWithError() throws {
        
        super.setUp()
        sut = PhotoGridViewModel(dataManager: PhotoGridDataManager(apiClient: PhotoGridApiClient()))
    }

    override func tearDownWithError() throws {
        
        sut = nil
        super.tearDown()
    }
    
    func testLoading() {
        
        var isLoading: Bool?
        let promise = expectation(description: "")
        
        sut.searchPhotos()
        sut
            .getLoading()
            .subscribe(onNext:{ loading in
                
                isLoading = loading
                promise.fulfill()
            })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(isLoading)
        XCTAssertFalse(isLoading!)
    }
    
    func testError() {
        
        var error: ErrorResponse?
        let promise = expectation(description: "")
        
        sut.searchPhotos()
        sut
            .getError()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { errorResponse in
                
                error = errorResponse
                promise.fulfill()
            })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(error)
    }
    
    func testSearchPhotosRight() throws {
        
        var photos: [PhotoCellViewModel]?
        let promise = expectation(description: "")
        
        sut.setTags(tags: "kitten")
        sut.searchPhotos()
        sut
            .getPhotoCellViewModels()
            .subscribe(onNext: { photosResponse in
                
                photos = photosResponse
                if (photosResponse.count > 0) {
                    promise.fulfill()
                }
            })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(photos)
        XCTAssertTrue(photos!.count > 0)
        XCTAssertTrue(sut.getPhotoCellViewModelsValue().count > 0)
    }
    
    func testSearchPhotosWrong() throws {
        
        var photos: [PhotoCellViewModel]?
        let promise = expectation(description: "")
        
        sut.searchPhotos()
        sut
            .getPhotoCellViewModels()
            .subscribe(onNext: { photosResponse in
                
                photos = photosResponse
                promise.fulfill()
            })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(photos)
        XCTAssertTrue(photos!.count == 0)
    }
    
    func testReloadDataRight() throws {
        
        sut.reloadData()
        XCTAssertTrue(sut.getPhotoCellViewModelsValue().count == 0)
    }
}
