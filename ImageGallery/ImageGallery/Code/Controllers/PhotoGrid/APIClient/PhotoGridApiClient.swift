//
//  PhotoGridApiClient.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PhotoGridApiClientProtocol {
    
    func searchPhotos(tags: String, page: Int)
    func getPhotoSizes(photo: PhotoResponse)
    func getSearchObserver() -> PublishSubject<SearchResponse>
    func getPhotoCellViewModelObserver() -> PublishSubject<PhotoCellViewModel>
    func getErrorObserver() -> PublishSubject<ErrorResponse>
}

class PhotoGridApiClient {
    
    // MARK: - Private variables
    
    private let searchObserver: PublishSubject<SearchResponse> = PublishSubject()
    private let photoCellViewModelObserver: PublishSubject<PhotoCellViewModel> = PublishSubject()
    private let errorObserver: PublishSubject<ErrorResponse> = PublishSubject()
}

// MARK: - PhotoGridApiClientProtocol

extension PhotoGridApiClient: PhotoGridApiClientProtocol {
    
    func searchPhotos(tags: String, page: Int) {
        
        let request = SearchImagesRequest(tags: tags,
                                          page: page)
        APIClient.shared.sendServer(request,
                                    success: { [weak self] searchResponse in
                                        self?.searchObserver.onNext(searchResponse)
                                    }, failure: { [weak self] errorResponse in
                                        self?.errorObserver.onNext(errorResponse)
                                    })
    }
    
    func getPhotoSizes(photo: PhotoResponse) {
        
        let request = GetSizesRequest(photoId: photo.id)
        APIClient.shared.sendServer(request,
                                    success: { [weak self] sizesResponse in
                                        
                                        let imageUrl = sizesResponse.sizes.size.first(where: { $0.label.elementsEqual("Large Square") })?.source
                                        let fullImageUrl = Constants.getFullImageUrl(sizes: sizesResponse.sizes.size)
                                        self?.photoCellViewModelObserver.onNext(PhotoCellViewModel(photo: photo,
                                                                                                   image: imageUrl,
                                                                                                   fullImage: fullImageUrl))
                                    }, failure: { [weak self] errorResponse in
                                        
                                        self?.photoCellViewModelObserver.onNext(PhotoCellViewModel(photo: photo,
                                                                                                   image: nil,
                                                                                                   fullImage: nil))
                                    })
    }
    
    func getSearchObserver() -> PublishSubject<SearchResponse> {
        return searchObserver
    }
    
    func getPhotoCellViewModelObserver() -> PublishSubject<PhotoCellViewModel> {
        return photoCellViewModelObserver
    }
    
    func getErrorObserver() -> PublishSubject<ErrorResponse> {
        return errorObserver
    }
}
