//
//  PhotoSizeResponse.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import Foundation

typealias PhotoSizesResponse = [PhotoSizeResponse]

struct PhotoSizeResponse: Codable {
    let label: String
    let width: Int
    let height: Int
    let source: String
    let url: String
    let media: String
}
