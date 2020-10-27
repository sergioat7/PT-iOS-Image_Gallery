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
    let disposeBag = DisposeBag()

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
        
        sut.viewDidLoad()
        sut.searchPhotos()
        sut
            .getLoadingObserver()
            .subscribe(onNext:{ loading in
                
                isLoading = loading
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(isLoading)
        XCTAssertFalse(isLoading!)
    }
    
    func testError() {
        
        var error: ErrorResponse?
        let promise = expectation(description: "")
        
        sut.viewDidLoad()
        sut.searchPhotos()
        sut
            .getErrorObserver()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { errorResponse in
                
                error = errorResponse
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(error)
    }
    
    func testSearchPhotosRight() throws {
        
        var photos: [PhotoCellViewModel]?
        let promise = expectation(description: "")
        
        sut.viewDidLoad()
        sut.setTags(tags: "kitten")
        sut.searchPhotos()
        sut
            .getPhotoCellViewModelsObserver()
            .subscribe(onNext: { photosResponse in
                
                photos = photosResponse
                if (photosResponse.count > 0) {
                    promise.fulfill()
                }
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 120)
        
        XCTAssertNotNil(photos)
        XCTAssertTrue(photos!.count > 0)
        XCTAssertTrue(sut.getPhotoCellViewModelsObserverValue().count > 0)
    }
    
    func testSearchPhotosWrong() throws {
        
        var photos: [PhotoCellViewModel]?
        let promise = expectation(description: "")
        
        sut.searchPhotos()
        sut
            .getPhotoCellViewModelsObserver()
            .subscribe(onNext: { photosResponse in
                
                photos = photosResponse
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 60)
        
        XCTAssertNotNil(photos)
        XCTAssertTrue(photos!.count == 0)
    }
    
    func testReloadDataRight() throws {
        
        sut.reloadData()
        XCTAssertTrue(sut.getPhotoCellViewModelsObserverValue().count == 0)
    }
}
