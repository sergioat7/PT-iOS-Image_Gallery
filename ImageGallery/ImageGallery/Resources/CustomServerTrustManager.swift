//
//  CustomServerTrustManager.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 24/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit
import Alamofire

class CustomServerTrustManager: ServerTrustManager {
    
    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        
        if let policy = try super.serverTrustEvaluator(forHost: host) {
            return policy
        } else {
            return CompositeTrustEvaluator(evaluators: [DefaultTrustEvaluator()])
        }
    }
}
