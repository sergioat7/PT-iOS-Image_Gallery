//
//  PhotoGridApiClient.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

protocol PhotoGridApiClientProtocol {
    
    func searchPhotos(tags: String, page: Int, success: @escaping (SearchResponse) -> Void, failure: @escaping (ErrorResponse) -> Void)
}

class PhotoGridApiClient: PhotoGridApiClientProtocol {
    
    func searchPhotos(tags: String, page: Int, success: @escaping (SearchResponse) -> Void, failure: @escaping (ErrorResponse) -> Void) {
        
        let request = SearchImagesRequest(tags: tags,
                                          page: page)
        APIClient.shared.sendServer(request, success: success, failure: failure)
    }
}
