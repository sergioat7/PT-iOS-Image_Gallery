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
    
    //HTTP Method
    var method: HTTPMethod { get }
    
    //Query parameters to be appended in url
    var queryParams: Parameters { get set }
}
