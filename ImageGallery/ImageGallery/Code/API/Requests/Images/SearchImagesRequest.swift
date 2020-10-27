//
//  SearchImagesRequest.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import Foundation
import Alamofire

class SearchImagesRequest: APIRequest {
    
    public typealias Response = SearchResponse
    
    public typealias Error = ErrorResponse
    
    public var method: HTTPMethod {
        return HTTPMethod.get
    }
    
    public var queryParams: Parameters
    
    public init(tags: String, page: Int) {
        
        queryParams = [Constants.methodQueryParam : Constants.searchPhotosMethod]
        self.queryParams[Constants.tagsQueryParam] = tags
        self.queryParams[Constants.pageQueryParam] = String(format: "%ld", page)
    }
}
