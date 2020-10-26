//
//  PhotoGridRouter.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

class PhotoGridRouter: BaseRouter {
    
    // MARK: - Public variables
    
    // MARK: - Private variables
    
    private var view:PhotoGridViewController {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "PhotoGridView",
                                                    bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "PhotoGrid") as? PhotoGridViewController {
            
            let viewModel: PhotoGridViewModelProtocol = PhotoGridViewModel(dataManager: dataManager)
            controller.set(viewModel: viewModel)
            return controller
        }
        return PhotoGridViewController()
    }
    
    private var dataManager: PhotoGridDataManagerProtocol {
        return PhotoGridDataManager(apiClient: apiClient)
    }
    
    private var apiClient: PhotoGridApiClientProtocol {
        return PhotoGridApiClient()
    }
    
    // MARK: - Initialization
    
    override init() {}
    
    // MARK: - Presentation Methods

    func push() {
        push(viewController: view)
    }
}

