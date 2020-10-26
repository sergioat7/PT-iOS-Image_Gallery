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
    
    func viewDidLoad()
    func getLoadingObserver() -> PublishSubject<Bool>
    func getErrorObserver() -> PublishSubject<ErrorResponse>
    func getPhotoCellViewModelsObserver() -> BehaviorSubject<[PhotoCellViewModel]>
    func getPhotoCellViewModelsObserverValue() -> [PhotoCellViewModel]
    func setTags(tags: String)
    func searchPhotos()
    func reloadData()
    func presentImageFullScreen(imageUrl: URL)
}

class PhotoGridViewModel: BaseViewModel {
        
    // MARK: - Private variables
    
    private var dataManager: PhotoGridDataManagerProtocol
    private let loadingObserver: PublishSubject<Bool> = PublishSubject()
    private let errorObserver: PublishSubject<ErrorResponse> = PublishSubject()
    private let photoCellViewModelsObserver: BehaviorSubject<[PhotoCellViewModel]> = BehaviorSubject(value: [])
    private let disposeBag = DisposeBag()
    private var tags = ""
    private var slideShowViewController: FullScreenSlideshowViewController!
    
    // MARK: - Initialization
    
    init(dataManager: PhotoGridDataManagerProtocol) {
        self.dataManager = dataManager
    }
}

extension PhotoGridViewModel: PhotoGridViewModelProtocol {
    
    func viewDidLoad() {
        
        dataManager
            .getPhotosObserver()
            .subscribe(onNext: { [weak self] photosResponse in
                self?.dataManager.getPhotoSizes(photosResponse: photosResponse)
            })
            .disposed(by: disposeBag)
        
        dataManager
            .getPhotoCellViewModelsObserver()
            .subscribe(onNext: { [weak self] photoCellViewModels in
                
                var newValue = self?.getPhotoCellViewModelsObserverValue() ?? []
                newValue.append(contentsOf: photoCellViewModels)
                self?.photoCellViewModelsObserver.onNext(newValue)
                self?.loadingObserver.onNext(false)
            })
            .disposed(by: disposeBag)
        
        dataManager
            .getErrorObserver()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorResponse in
                
                self?.loadingObserver.onNext(false)
                self?.errorObserver.onNext(errorResponse)
                self?.photoCellViewModelsObserver.onNext([])
            })
            .disposed(by: disposeBag)
    }
    
    func getLoadingObserver() -> PublishSubject<Bool> {
        return loadingObserver
    }
    
    func getErrorObserver() -> PublishSubject<ErrorResponse> {
        return errorObserver
    }
    
    func getPhotoCellViewModelsObserver() -> BehaviorSubject<[PhotoCellViewModel]> {
        return photoCellViewModelsObserver
    }
    
    func getPhotoCellViewModelsObserverValue() -> [PhotoCellViewModel] {
        
        do {
            return try photoCellViewModelsObserver.value()
        } catch {
            return []
        }
    }
    
    func setTags(tags: String) {
        self.tags = tags
    }
    
    func searchPhotos() {
        dataManager.searchPhotos(tags: tags)
    }
    
    func reloadData() {
        
        dataManager.resetPage()
        photoCellViewModelsObserver.onNext([])
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

