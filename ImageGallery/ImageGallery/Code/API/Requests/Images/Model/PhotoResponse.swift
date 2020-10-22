//
//  PhotoResponse.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import Foundation

typealias PhotosResponse = [PhotoResponse]

struct PhotoResponse: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}
