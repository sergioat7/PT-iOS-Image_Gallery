//
//  PhotoGridDataManagerTests.swift
//  ImageGalleryTests
//
//  Created by Sergio Aragonés on 25/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import ImageGallery

class PhotoGridDataManagerTests: XCTestCase {
    
    var sut: PhotoGridDataManager!
    let disposeBag = DisposeBag()

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
        
        let promise = expectation(description: "Search successful")
        sut.searchPhotos(tags: "kitten")
        sut
            .getPhotosObserver()
            .subscribe(onNext: { photosResponse in
                
                photos = photosResponse
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(photos)
        XCTAssertTrue(photos!.count > 0)
    }

    func testSearchPhotosWrong() throws {
        
        var error: ErrorResponse?
        
        let promise = expectation(description: "Search unsuccessful")
        sut.searchPhotos(tags: "")
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
        sut.getPhotoSizes(photosResponse: [photo])
        sut
            .getPhotoCellViewModelsObserver()
            .subscribe(onNext: { photoCellViewModels in
                
                photoCellViewModel = photoCellViewModels.first
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
        sut.getPhotoSizes(photosResponse: [photo])
        sut
            .getPhotoCellViewModelsObserver()
            .subscribe(onNext: { photoCellViewModels in
                
                photoCellViewModel = photoCellViewModels.first
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(photoCellViewModel)
        XCTAssertNil(photoCellViewModel!.imageUrl)
    }
}
