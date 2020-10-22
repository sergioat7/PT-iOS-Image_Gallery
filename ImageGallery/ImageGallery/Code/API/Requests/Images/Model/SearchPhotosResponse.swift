//
//  SearchPhotosResponse.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import Foundation

struct SearchPhotosResponse: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: PhotosResponse
}
