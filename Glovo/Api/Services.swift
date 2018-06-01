//
//  Services.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation
import Alamofire

struct Services {
    
    class GetCountries: ApiMethod {
        var completionHandler: ((Any?, ApiError?)->())? = nil

        convenience init(completionHandler: ((Any?, ApiError?)->())?) {
            self.init()
            self.completionHandler = completionHandler
        }
        
        private init() {
            super.init(headers: [:], parameters: [:])
        }
        
        override func endpoint() -> String {
            return getConfiguration().baseUrl + getConfiguration().countriesEndpoint
        }
        
        override func onSuccess(result: Any?) {
            if result != nil {
                self.completionHandler?(result, nil)
            } else {
                self.completionHandler?(nil, ApiError(response: result))
            }
        }
        
        override func onFailure(error: ApiError) {
            self.completionHandler?(nil, error)
        }
    }
    
    class GetCities: ApiMethod {
        var completionHandler: ((Any?, ApiError?)->())? = nil
        
        convenience init(completionHandler: ((Any?, ApiError?)->())?) {
            self.init()
            self.completionHandler = completionHandler
        }
        
        private init() {
            super.init(headers: [:], parameters: [:])
        }
        
        override func endpoint() -> String {
            return getConfiguration().baseUrl + getConfiguration().citiesEndpoint
        }
        
        override func onSuccess(result: Any?) {
            if result != nil {
                self.completionHandler?(result, nil)
            } else {
                self.completionHandler?(nil, ApiError(response: result))
            }
        }
        
        override func onFailure(error: ApiError) {
            self.completionHandler?(nil, error)
        }
    }
    
    class GetCity: ApiMethod {
        var completionHandler: ((Any?, ApiError?)->())? = nil
        var city: String = ""
        
        convenience init(city: String, completionHandler: ((Any?, ApiError?)->())?) {
            self.init()
            self.completionHandler = completionHandler
            self.city = city
        }
        
        private init() {
            super.init(headers: [:], parameters: [:])
        }
        
        override func endpoint() -> String {
            return getConfiguration().baseUrl + getConfiguration().citiesEndpoint + "/\(city)"
        }
        
        override func onSuccess(result: Any?) {
            if result != nil {
                self.completionHandler?(result, nil)
            } else {
                self.completionHandler?(nil, ApiError(response: result))
            }
        }
        
        override func onFailure(error: ApiError) {
            self.completionHandler?(nil, error)
        }
    }
    
}
