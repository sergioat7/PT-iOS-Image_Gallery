//
//  PhotoGridDataManagerTests.swift
//  ImageGalleryTests
//
//  Created by Sergio Aragonés on 25/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import XCTest
@testable import ImageGallery

class PhotoGridDataManagerTests: XCTestCase {
    
    var sut: PhotoGridDataManager!

    override func setUpWithError() throws {
        
        super.setUp()
        sut = PhotoGridDataManager(apiClient: PhotoGridApiClient())
    }

    override func tearDownWithError() throws {
        
        sut = nil
        super.tearDown()
    }
    
    func testSearchPhotosRight() throws {
        
        var photos: PhotosResponse?
        var error: ErrorResponse?
        
        let promise = expectation(description: "Search successful")
        sut.searchPhotos(tags: "kitten",
                         success: { photosResponse in
                            
                            photos = photosResponse
                            promise.fulfill()
                         }, failure: { errorResponse in
                            
                            error = errorResponse
                            promise.fulfill()
                         })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(photos)
        XCTAssertTrue(photos!.count > 0)
        XCTAssertNil(error)
    }

    func testSearchPhotosWrong() throws {
        
        var photos: PhotosResponse?
        var error: ErrorResponse?
        
        let promise = expectation(description: "Search unsuccessful")
        sut.searchPhotos(tags: "",
                         success: { photosResponse in
                            
                            photos = photosResponse
                            promise.fulfill()
                         }, failure: { errorResponse in
                            
                            error = errorResponse
                            promise.fulfill()
                         })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNil(photos)
        XCTAssertNotNil(error)
    }
    
    func testGetPhotoSizesRight() throws {
        
        var sizes: PhotoSizesResponse?
        var error: ErrorResponse?
        
        let promise = expectation(description: "Get sizes successful")
        sut.getPhotoSizes(photoId: "50528729953",
                          success: { photoSizesResponse in
                            
                            sizes = photoSizesResponse
                            promise.fulfill()
                         }, failure: { errorResponse in
                            
                            error = errorResponse
                            promise.fulfill()
                         })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(sizes)
        XCTAssertTrue(sizes!.count > 0)
        XCTAssertNil(error)
    }

    func testGetPhotoSizesWrong() throws {
        
        var sizes: PhotoSizesResponse?
        var error: ErrorResponse?
        
        let promise = expectation(description: "Get sizes unsuccessful")
        sut.getPhotoSizes(photoId: "",
                          success: { photoSizesResponse in
                            
                            sizes = photoSizesResponse
                            promise.fulfill()
                         }, failure: { errorResponse in
                            
                            error = errorResponse
                            promise.fulfill()
                         })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNil(sizes)
        XCTAssertNotNil(error)
    }
}
