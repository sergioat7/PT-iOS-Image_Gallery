//
//  PhotoGridDataManager.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PhotoGridDataManagerProtocol: class {
    
    func searchPhotos(tags: String)
    func getPhotoSizes(photosResponse: PhotosResponse)
    func resetPage()
    func getPhotosObserver() -> PublishSubject<PhotosResponse>
    func getPhotoCellViewModelsObserver() -> PublishSubject<[PhotoCellViewModel]>
    func getErrorObserver() -> PublishSubject<ErrorResponse>
}

class PhotoGridDataManager: BaseDataManager {
    
    // MARK: - Public variables
    
    // MARK: - Private variables
    
    private let apiClient: PhotoGridApiClientProtocol
    private let photosObserver: PublishSubject<PhotosResponse> = PublishSubject()
    private let photoCellViewModelsObserver: PublishSubject<[PhotoCellViewModel]> = PublishSubject()
    private let errorObserver: PublishSubject<ErrorResponse> = PublishSubject()
    private var page: Int = 1
    
    // MARK: - Initialization
    
    init(apiClient: PhotoGridApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension PhotoGridDataManager: PhotoGridDataManagerProtocol {
    
    func searchPhotos(tags: String) {
        
        apiClient.searchPhotos(tags: tags,
                               page: page,
                               success: { searchResponse in
                                
                                self.page += 1
                                if self.page > searchResponse.photos.pages {
                                    self.page = 1
                                }
                                self.photosObserver.onNext(searchResponse.photos.photo)
                               }, failure: { errorResponse in
                                self.errorObserver.onNext(errorResponse)
                               })
    }
    
    func getPhotoSizes(photosResponse: PhotosResponse) {
        
        var photoCellViewModels: [PhotoCellViewModel] = []
        for photoResponse in photosResponse {
            
            apiClient.getPhotoSizes(photoId: photoResponse.id,
                                    success: { sizesResponse in
                                        
                                        let imageUrl = sizesResponse.sizes.size.first(where: { $0.label.elementsEqual("Large Square") })?.source
                                        let fullImageUrl = self.getFullImageUrl(sizes: sizesResponse.sizes.size)
                                        photoCellViewModels.append(PhotoCellViewModel(photo: photoResponse,
                                                                                      image: imageUrl,
                                                                                      fullImage: fullImageUrl))
                                        if (photoCellViewModels.count == photosResponse.count) {
                                            self.photoCellViewModelsObserver.onNext(photoCellViewModels)
                                        }
                                    }, failure: { _ in
                                        if (photoCellViewModels.count == photosResponse.count) {
                                            self.photoCellViewModelsObserver.onNext(photoCellViewModels)
                                        }
                                    })
        }
    }
    
    func resetPage() {
        page = 1
    }
    
    func getPhotosObserver() -> PublishSubject<PhotosResponse> {
        return photosObserver
    }
    
    func getPhotoCellViewModelsObserver() -> PublishSubject<[PhotoCellViewModel]> {
        return photoCellViewModelsObserver
    }
    
    func getErrorObserver() -> PublishSubject<ErrorResponse> {
        return errorObserver
    }
    
    // MARK: - Private functions
    
    private func getFullImageUrl(sizes: PhotoSizesResponse) -> String? {
        
        if let large = sizes.first(where: { $0.label.elementsEqual("Large") })?.source {
            return large
        } else if let large = sizes.first(where: { $0.label.elementsEqual("Original") })?.source {
            return large
        } else if let large2048 = sizes.first(where: { $0.label.elementsEqual("Large 2048") })?.source {
            return large2048
        } else if let large1600 = sizes.first(where: { $0.label.elementsEqual("Large 1600") })?.source {
            return large1600
        } else {
            return nil
        }
    }
}
