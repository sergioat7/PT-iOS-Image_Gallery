//
//  PhotoGridDataManager.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

protocol PhotoGridDataManagerProtocol: class {
    /**
     * Add here your methods for communication VIEW_MODEL -> DATA_MANAGER
     */
}

class PhotoGridDataManager: BaseDataManager {
    
    // MARK: - Public variables
    
    private let apiClient: PhotoGridApiClientProtocol
    
    // MARK: - Private variables
    
    // MARK: - Initialization
    
    init(apiClient: PhotoGridApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension PhotoGridDataManager: PhotoGridDataManagerProtocol {
    
}

