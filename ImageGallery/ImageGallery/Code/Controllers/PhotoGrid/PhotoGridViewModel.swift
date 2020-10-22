//
//  PhotoGridViewModel.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

protocol PhotoGridViewModelProtocol: class {
    /**
     * Add here your methods for communication VIEW -> VIEW_MODEL
     */
}

class PhotoGridViewModel: BaseViewModel {
    
    // MARK: - Public variables
    
    weak var view:PhotoGridViewProtocol?
    
    // MARK: - Private variables
    
    private var dataManager: PhotoGridDataManagerProtocol
    
    // MARK: - Initialization
    
    init(view:PhotoGridViewProtocol,
         dataManager: PhotoGridDataManagerProtocol) {
        self.view = view
        self.dataManager = dataManager
    }
}

extension PhotoGridViewModel: PhotoGridViewModelProtocol {
    
}

