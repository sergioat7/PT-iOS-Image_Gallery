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
    
    init(photo: PhotoResponse,
         image: String?) {
        
        self.photo = photo
        self.image = image
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
}

