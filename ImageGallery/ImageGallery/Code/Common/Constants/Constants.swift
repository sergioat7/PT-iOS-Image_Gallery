//
//  Constants.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

struct Constants {

    // MARK: - Network constants
    
    static let host = "api.flickr.com"
    static let methodQueryParam = "method"
    static let tagsQueryParam = "tags"
    static let pageQueryParam = "page"
    static let photoIdQueryParam = "photo_id"
    static let searchPhotosMethod = "flickr.photos.search"
    static let getSizesMethod = "flickr.photos.getSizes"
    
    // MARK: - Collection view constants
    
    static let cellName = "PhotoCell"
    
    static func getFullImageUrl(sizes: PhotoSizesResponse) -> String? {
        
        if let large = sizes.first(where: { $0.label.elementsEqual("Large") })?.source {
            return large
        } else if let large = sizes.first(where: { $0.label.elementsEqual("Original") })?.source {
            return large
        } else if let large2048 = sizes.first(where: { $0.label.elementsEqual("Large 2048") })?.source {
            return large2048
        } else if let large1600 = sizes.first(where: { $0.label.elementsEqual("Large 1600") })?.source {
            return large1600
        } else {
            return nil
        }
    }

}
