//
//  PhotoGridApiClientTests.swift
//  ImageGalleryTests
//
//  Created by Sergio Aragonés on 25/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import ImageGallery

class PhotoGridApiClientTests: XCTestCase {
    
    var sut: PhotoGridApiClient!
    let disposeBag = DisposeBag()
    
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
        
        let promise = expectation(description: "Search successful")
        sut.searchPhotos(tags: "kitten", page: 1)
        sut
            .getSearchObserver()
            .subscribe(onNext: { searchResponse in
                
                searchedPhotos = searchResponse.photos
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(searchedPhotos)
        XCTAssertTrue(searchedPhotos!.photo.count > 0)
    }

    func testSearchPhotosWrong() throws {
        
        var error: ErrorResponse?
        
        let promise = expectation(description: "Search unsuccessful")
        sut.searchPhotos(tags: "", page: 1)
        sut
            .getErrorObserver()
            .subscribe(onNext: { errorResponse in
                
                error = errorResponse
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(error)
    }
    
    func testGetPhotoSizesRight() throws {
        
        let photo = PhotoResponse(id: "50528729953",
                                  owner: "",
                                  secret: "",
                                  server: "",
                                  farm: 1,
                                  title: "",
                                  ispublic: 1,
                                  isfriend: 1,
                                  isfamily: 1)
        var photoCellViewModel: PhotoCellViewModel?
        
        let promise = expectation(description: "Get sizes successful")
        sut.getPhotoSizes(photo: photo)
        sut
            .getPhotoCellViewModelObserver()
            .subscribe(onNext: { photoCellViewModelResponse in
                
                photoCellViewModel = photoCellViewModelResponse
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(photoCellViewModel)
    }

    func testGetPhotoSizesWrong() throws {
        
        let photo = PhotoResponse(id: "",
                                  owner: "",
                                  secret: "",
                                  server: "",
                                  farm: 1,
                                  title: "",
                                  ispublic: 1,
                                  isfriend: 1,
                                  isfamily: 1)
        var photoCellViewModel: PhotoCellViewModel?
        
        let promise = expectation(description: "Get sizes unsuccessful")
        sut.getPhotoSizes(photo: photo)
        sut
            .getPhotoCellViewModelObserver()
            .subscribe(onNext: { photoCellViewModelResponse in
                
                photoCellViewModel = photoCellViewModelResponse
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(photoCellViewModel)
        XCTAssertNil(photoCellViewModel!.imageUrl)
    }
}
