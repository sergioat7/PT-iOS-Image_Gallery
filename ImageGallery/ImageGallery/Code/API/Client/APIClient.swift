//
//  APIClient.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 22/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import Foundation
import Alamofire
import SwifterSwift

public class APIClient {
    
    static let shared = APIClient()
    
    let session = Session(configuration: URLSessionConfiguration.default)
    public var baseEndpoint: String {
        return "https://api.flickr.com/services/rest"
    }
    
    func sendServer<T: APIRequest>(_ request: T,
                                   success: @escaping (T.Response) -> Void,
                                   failure: @escaping (ErrorResponse) -> Void) {
        
        var endpoint = self.endpoint(for: request)
        let method = request.method
        
        endpoint.appendQueryParameters(request.queryParams)
        endpoint.appendQueryParameters(["format" : "json"])
        endpoint.appendQueryParameters(["nojsoncallback" : "1"])
        endpoint.appendQueryParameters(["api_key" : "f9cc014fa76b098f9e82f1c288379ea1"])
//        var parameters: Parameters = request.queryParams
//        parameters["format"] = "json"
//        parameters["nojsoncallback"] = "1"
//        parameters["api_key"] = "f9cc014fa76b098f9e82f1c288379ea1"
        
        let request = session.request(endpoint,
                                      method: method,
//                                      parameters: parameters,
//                                      encoding: URLEncoding(destination: .queryString),
                                      encoding: JSONEncoding.default).validate()
        request.responseJSON { response in
            
            let statusCode = response.response?.statusCode ?? -1
            
            if statusCode < 400, let data = response.data {
                do {
                    let response = try JSONDecoder().decode(T.Response.self, from: data)
                    success(response)
                    return
                } catch {
                    self.mapErrorData(data: data, failure: failure)
                }
            } else if statusCode >= 400 && statusCode < 500, let data = response.data {
                self.mapErrorData(data: data, failure: failure)
            } else {
                let errorResponse = ErrorResponse(message: "ERROR_SERVER".localized())
                failure(errorResponse)
                return
            }
        }
    }
    
    // MARK: - Private functions
    
    private func endpoint<T: APIRequest>(for request: T) -> URL {
        
        let urlString = "\(baseEndpoint)\(request.resourceName)\(request.resourcePath)"
        return URL(string: urlString)!
    }
    
    private func mapErrorData(data: Data, failure: @escaping (ErrorResponse) -> Void) {
        
        do {
            let response = try JSONDecoder().decode(ErrorResponse.self, from: data)
            failure(response)
            return
        } catch {
            let error = ErrorResponse(message: "ERROR_SERVER".localized())
            failure(error)
            return
        }
    }
}

