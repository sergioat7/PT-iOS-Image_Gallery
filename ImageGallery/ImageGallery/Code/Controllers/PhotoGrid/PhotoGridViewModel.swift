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
    
    private func getContent(tags: String) {
        
        view?.showLoading()
        dataManager.searchPhotos(tags: tags, success: { photosResponse in
            
            let photoCellViewModels = photosResponse.compactMap({ photoResponse -> PhotoCellViewModel in
                return PhotoCellViewModel(photo: photoResponse)
            })
            self.photoCellViewModels = photoCellViewModels
            self.view?.showPhotos()
            self.view?.hideLoading()
        }, failure: { errorResponse in
            self.view?.hideLoading()
        })
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

