//
//  PhotoGridApiClientTests.swift
//  ImageGalleryTests
//
//  Created by Sergio Aragonés on 25/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import XCTest
@testable import ImageGallery

class PhotoGridApiClientTests: XCTestCase {
    
    var sut: PhotoGridApiClient!
    
    override func setUp() {
        
        super.setUp()
        sut = PhotoGridApiClient()
    }

    override func tearDown() {
        
        sut = nil
        super.tearDown()
    }

    func testSearchPhotosRight() throws {
        
        var searchedPhotos: SearchPhotosResponse?
        var error: ErrorResponse?
        
        let promise = expectation(description: "Search successful")
        sut.searchPhotos(tags: "kitten",
                         page: 1,
                         success: { searchResponse in
                            
                            searchedPhotos = searchResponse.photos
                            promise.fulfill()
                         }, failure: { errorResponse in
                            
                            error = errorResponse
                            promise.fulfill()
                         })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(searchedPhotos)
        XCTAssertTrue(searchedPhotos!.photo.count > 0)
        XCTAssertNil(error)
    }

    func testSearchPhotosWrong() throws {
        
        var searchedPhotos: SearchPhotosResponse?
        var error: ErrorResponse?
        
        let promise = expectation(description: "Search unsuccessful")
        sut.searchPhotos(tags: "",
                         page: 1,
                         success: { searchResponse in
                            
                            searchedPhotos = searchResponse.photos
                            promise.fulfill()
                         }, failure: { errorResponse in
                            
                            error = errorResponse
                            promise.fulfill()
                         })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNil(searchedPhotos)
        XCTAssertNotNil(error)
    }
    
    func testGetPhotoSizesRight() throws {
        
        var sizes: SizePhotoResponse?
        var error: ErrorResponse?
        
        let promise = expectation(description: "Get sizes successful")
        sut.getPhotoSizes(photoId: "50528729953",
                          success: { sizesResponse in
                            
                            sizes = sizesResponse.sizes
                            promise.fulfill()
                         }, failure: { errorResponse in
                            
                            error = errorResponse
                            promise.fulfill()
                         })
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(sizes)
        XCTAssertTrue(sizes!.size.count > 0)
        XCTAssertNil(error)
    }

    func testGetPhotoSizesWrong() throws {
        
        var sizes: SizePhotoResponse?
        var error: ErrorResponse?
        
        let promise = expectation(description: "Get sizes unsuccessful")
        sut.getPhotoSizes(photoId: "",
                          success: { sizesResponse in
                            
                            sizes = sizesResponse.sizes
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
