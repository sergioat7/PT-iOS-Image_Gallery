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
    
    // MARK: - Private variables
    
    private let apiClient: PhotoGridApiClientProtocol
    private let photosObserver: PublishSubject<PhotosResponse> = PublishSubject()
    private let photoCellViewModelsObserver: PublishSubject<[PhotoCellViewModel]> = PublishSubject()
    private let disposeBag = DisposeBag()
    private var page: Int = 1
    
    // MARK: - Initialization
    
    init(apiClient: PhotoGridApiClientProtocol) {
        self.apiClient = apiClient
    }
}

// MARK: - PhotoGridDataManagerProtocol

extension PhotoGridDataManager: PhotoGridDataManagerProtocol {
    
    func searchPhotos(tags: String) {
        
        apiClient.searchPhotos(tags: tags, page: page)
        
        apiClient
            .getSearchObserver()
            .subscribe(onNext: { [weak self] searchResponse in
                
                guard let strongSelf = self else { return }
                strongSelf.page += 1
                if strongSelf.page > searchResponse.photos.pages {
                    strongSelf.page = 1
                }
                strongSelf.photosObserver.onNext(searchResponse.photos.photo)
            })
            .disposed(by: disposeBag)
    }
    
    func getPhotoSizes(photosResponse: PhotosResponse) {
        
        for photoResponse in photosResponse {
            apiClient.getPhotoSizes(photo: photoResponse)
        }
        
        var photoCellViewModels: [PhotoCellViewModel] = []
        apiClient
            .getPhotoCellViewModelObserver()
            .subscribe(onNext: { [weak self] photoCellViewModelResponse in
                
                photoCellViewModels.append(photoCellViewModelResponse)
                if (photoCellViewModels.count == photosResponse.count) {
                    self?.photoCellViewModelsObserver.onNext(photoCellViewModels)
                }
            })
            .disposed(by: disposeBag)
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
        return apiClient.getErrorObserver()
    }
}
