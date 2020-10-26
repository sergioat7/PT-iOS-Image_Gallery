//
//  PhotoGridViewModel.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit
import ImageSlideshow
import RxSwift
import RxCocoa

protocol PhotoGridViewModelProtocol: class {
    
    func getLoading() -> PublishSubject<Bool>
    func getError() -> PublishSubject<ErrorResponse>
    func getPhotoCellViewModels() -> BehaviorSubject<[PhotoCellViewModel]>
    func getPhotoCellViewModelsValue() -> [PhotoCellViewModel]
    func setTags(tags: String)
    func searchPhotos()
    func reloadData()
    func presentImageFullScreen(imageUrl: URL)
}

class PhotoGridViewModel: BaseViewModel {
    
    // MARK: - Public variables
        
    // MARK: - Private variables
    
    private var dataManager: PhotoGridDataManagerProtocol
    private let loading: PublishSubject<Bool> = PublishSubject()
    private let error: PublishSubject<ErrorResponse> = PublishSubject()
    private let photoCellViewModels: BehaviorSubject<[PhotoCellViewModel]> = BehaviorSubject(value: [])
    private var tags = ""
    private var slideShowViewController: FullScreenSlideshowViewController!
    
    // MARK: - Initialization
    
    init(dataManager: PhotoGridDataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    // MARK: - Private methods
    
    private func getContent(tags: String) {
        
        dataManager.searchPhotos(tags: tags, success: { photosResponse in
            self.getSizeContent(photosResponse: photosResponse, success: { photoCellViewModels in
                
                var newValue = self.getPhotoCellViewModelsValue()
                newValue.append(contentsOf: photoCellViewModels)
                self.photoCellViewModels.onNext(newValue)
                self.loading.onNext(false)
            })
        }, failure: { errorResponse in
            
            self.loading.onNext(false)
            self.error.onNext(errorResponse)
            self.photoCellViewModels.onNext([])
        })
    }
    
    private func getSizeContent(photosResponse: PhotosResponse, success: @escaping ([PhotoCellViewModel]) -> Void) {
        
        var photoCellViewModels: [PhotoCellViewModel] = []
        for photoResponse in photosResponse {
            
            dataManager.getPhotoSizes(photoId: photoResponse.id,
                                      success: { photoSizesResponse in
                                        
                                        let imageUrl = photoSizesResponse.first(where: { $0.label.elementsEqual("Large Square") })?.source
                                        let fullImageUrl = photoSizesResponse.first(where: { $0.label.elementsEqual("Large") })?.source
                                        photoCellViewModels.append(PhotoCellViewModel(photo: photoResponse,
                                                                                      image: imageUrl,
                                                                                      fullImage: fullImageUrl))
                                        if (photoCellViewModels.count == photosResponse.count) {
                                            success(photoCellViewModels)
                                        }
                                      }, failure: { _ in
                                        
                                        photoCellViewModels.append(PhotoCellViewModel(photo: photoResponse,
                                                                                      image: nil,
                                                                                      fullImage: nil))
                                        if (photoCellViewModels.count == photosResponse.count) {
                                            success(photoCellViewModels)
                                        }
                                      })
        }
    }
}

extension PhotoGridViewModel: PhotoGridViewModelProtocol {
    
    func getLoading() -> PublishSubject<Bool> {
        return loading
    }
    
    func getError() -> PublishSubject<ErrorResponse> {
        return error
    }
    
    func getPhotoCellViewModels() -> BehaviorSubject<[PhotoCellViewModel]> {
        return photoCellViewModels
    }
    
    func getPhotoCellViewModelsValue() -> [PhotoCellViewModel] {
        
        do {
            return try photoCellViewModels.value()
        } catch {
            return []
        }
    }
    
    func setTags(tags: String) {
        self.tags = tags
    }
    
    func searchPhotos() {
        getContent(tags: tags)
    }
    
    func reloadData() {
        
        dataManager.resetPage()
        photoCellViewModels.onNext([])
    }
    
    func presentImageFullScreen(imageUrl: URL) {
        
        let images = [AlamofireSource(url: imageUrl)]
        slideShowViewController = FullScreenSlideshowViewController()
        slideShowViewController.inputs = images
        slideShowViewController.slideshow.contentScaleMode = .scaleAspectFit
        
        UIViewController.getCurrentViewController()?.present(slideShowViewController,
                                                             animated: true)
    }
}

