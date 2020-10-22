//
//  GetSizesRequest.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import Foundation
import Alamofire

class GetSizesRequest: APIRequest {
    
    public typealias Response = SizesResponse
    
    public typealias Error = ErrorResponse
    
    public var method: HTTPMethod {
        return HTTPMethod.get
    }
    
    public var queryParams: Parameters
    
    public init(photoId: String) {
        
        queryParams = [Constants.methodQueryParam : Constants.getSizesMethod]
        self.queryParams[Constants.photoIdQueryParam] = photoId
    }
}
