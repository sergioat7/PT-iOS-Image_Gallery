//
//  PhotoCellViewModel.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 23/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

class PhotoCellViewModel {

    private let photo: PhotoResponse
    
    init(photo: PhotoResponse) {
        self.photo = photo
    }
    
    var id: String {
        get {
            return photo.id
        }
    }
    
    var title: String {
        get {
            return photo.title
        }
    }
}

