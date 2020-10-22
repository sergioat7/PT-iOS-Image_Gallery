//
//  APIRequest.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import Foundation
import Alamofire

public protocol APIRequest {
    
    associatedtype Response: Decodable

    // Endpoint for this request (the last part of the URL)
    var resourceName: String { get }
    
    //HTTP Method
    var method: HTTPMethod { get }
    
    //Parameters to be appended in url
    var resourcePath: String { get }
    
    //Query parameters to be appended in url
    var queryParams: [String : String] { get }
}
