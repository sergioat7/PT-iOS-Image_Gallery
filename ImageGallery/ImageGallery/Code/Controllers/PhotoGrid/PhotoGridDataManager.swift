//
//  PhotoGridDataManager.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

protocol PhotoGridDataManagerProtocol: class {
    
    func searchPhotos(tags: String, success: @escaping (PhotosResponse) -> Void, failure: @escaping (ErrorResponse) -> Void)
}

class PhotoGridDataManager: BaseDataManager {
    
    // MARK: - Public variables
    
    // MARK: - Private variables
    
    private let apiClient: PhotoGridApiClientProtocol
    private var page: Int = 1
    
    // MARK: - Initialization
    
    init(apiClient: PhotoGridApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension PhotoGridDataManager: PhotoGridDataManagerProtocol {
    
    func searchPhotos(tags: String, success: @escaping (PhotosResponse) -> Void, failure: @escaping (ErrorResponse) -> Void) {
        
        apiClient.searchPhotos(tags: tags,
                               page: page,
                               success: { searchResponse in
                                
                                self.page += 1
                                if self.page > searchResponse.photos.pages {
                                    self.page = 1
                                }
                                success(searchResponse.photos.photo)
                               }, failure: failure)
    }
}
