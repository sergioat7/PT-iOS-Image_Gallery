//
//  PhotoGridViewModel.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit
import ImageSlideshow

protocol PhotoGridViewModelProtocol: class {
    
    func setTags(tags: String)
    func searchPhotos()
    func getPhotoCellViewModels() -> [PhotoCellViewModel]
    func reloadData()
    func presentImageFullScreen(imageUrl: URL)
}

class PhotoGridViewModel: BaseViewModel {
    
    // MARK: - Public variables
    
    weak var view:PhotoGridViewProtocol?
    
    // MARK: - Private variables
    
    private var dataManager: PhotoGridDataManagerProtocol
    private var tags = ""
    private var photoCellViewModels: [PhotoCellViewModel] = []
    private var slideShowViewController: FullScreenSlideshowViewController!
    
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
        
        dataManager.searchPhotos(tags: tags, success: { photosResponse in
            self.getSizeContent(photosResponse: photosResponse, success: { photoCellViewModels in
                
                self.photoCellViewModels.append(contentsOf: photoCellViewModels)
                self.view?.showPhotos()
                self.view?.hideLoading()
            })
        }, failure: { errorResponse in
            self.manageError(error: errorResponse)
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
    
    func setTags(tags: String) {
        
        view?.showLoading()
        self.tags = tags
        reloadData()
        searchPhotos()
    }
    
    func searchPhotos() {
        getContent(tags: tags)
    }
    
    func getPhotoCellViewModels() -> [PhotoCellViewModel] {
        return photoCellViewModels
    }
    
    func reloadData() {
        
        dataManager.resetPage()
        photoCellViewModels = []
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
