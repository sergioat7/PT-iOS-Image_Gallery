//
//  SizePhotoResponse.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import Foundation

struct SizePhotoResponse: Codable {
    let canblog: Int
    let canprint: Int
    let candownload: Int
    let size: PhotoSizesResponse
}
