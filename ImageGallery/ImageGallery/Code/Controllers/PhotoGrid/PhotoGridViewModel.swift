//
//  PhotoGridViewModel.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

protocol PhotoGridViewModelProtocol: class {
    
    func searchPhotos(tags: String)
    func getPhotoCellViewModels() -> [PhotoCellViewModel]
}

class PhotoGridViewModel: BaseViewModel {
    
    // MARK: - Public variables
    
    weak var view:PhotoGridViewProtocol?
    
    // MARK: - Private variables
    
    private var dataManager: PhotoGridDataManagerProtocol
    private var photoCellViewModels: [PhotoCellViewModel] = []
    
    // MARK: - Initialization
    
    init(view:PhotoGridViewProtocol,
         dataManager: PhotoGridDataManagerProtocol) {
        
        self.view = view
        self.dataManager = dataManager
    }
    
    // MARK: - Private methods
    
    private func manageError(error: ErrorResponse) {

        view?.hideLoading()
        view?.showError(message: error.message,
                        handler: nil)
    }
    
    private func getContent(tags: String) {
        
        view?.showLoading()
        dataManager.searchPhotos(tags: tags, success: { photosResponse in
            self.getSizeContent(photosResponse: photosResponse, success: { photoCellViewModels in
                
                self.photoCellViewModels = photoCellViewModels
                self.view?.showPhotos()
                self.view?.hideLoading()
            })
        }, failure: { errorResponse in
            self.manageError(error: errorResponse)
        })
    }
    
    private func getSizeContent(photosResponse: PhotosResponse, success: @escaping ([PhotoCellViewModel]) -> Void) {
        
        var photoCellViewModels: [PhotoCellViewModel] = []
        for (index, photoResponse) in photosResponse.enumerated() {
            
            dataManager.getPhotoSizes(photoId: photoResponse.id,
                                      success: { photoSizesResponse in
                                        
                                        let imageUrl = photoSizesResponse
                                            .first(where: { $0.label.elementsEqual("Large Square") })?
                                            .source
                                        photoCellViewModels.append(PhotoCellViewModel(photo: photoResponse,
                                                                                      image: imageUrl))
                                        if (photoCellViewModels.count == photosResponse.count) {
                                            success(photoCellViewModels)
                                        }
                                      }, failure: { _ in
                                        
                                        photoCellViewModels.append(PhotoCellViewModel(photo: photoResponse,
                                                                                      image: nil))
                                        if (photoCellViewModels.count == photosResponse.count) {
                                            success(photoCellViewModels)
                                        }
                                      })
        }
    }
}

extension PhotoGridViewModel: PhotoGridViewModelProtocol {
    
    func searchPhotos(tags: String) {
        getContent(tags: tags)
    }
    
    func getPhotoCellViewModels() -> [PhotoCellViewModel] {
        return photoCellViewModels
    }
}

