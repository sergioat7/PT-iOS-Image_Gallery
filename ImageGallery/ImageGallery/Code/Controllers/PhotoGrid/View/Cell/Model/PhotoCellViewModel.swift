//
//  PhotoCellViewModel.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 23/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

class PhotoCellViewModel {

    private let photo: PhotoResponse
    private let image: String?
    private let fullImage: String?
    
    init(photo: PhotoResponse,
         image: String?,
         fullImage: String?) {
        
        self.photo = photo
        self.image = image
        self.fullImage = fullImage
    }
    
    var id: String {
        get {
            return photo.id
        }
    }
    
    var imageUrl: String? {
        get {
            return image
        }
    }
    
    var title: String {
        get {
            return photo.title
        }
    }
    
    var fullImageUrl: String? {
        get {
            return fullImage
        }
    }
}

