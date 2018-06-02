//
//  ApiService.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation

protocol ApiService {
    func getCountries(completionHandler: ((Any?, ApiError?)->())?)
    func getCities(completionHandler: ((Any?, ApiError?)->())?)
    func getCity(_ cityName: String, completionHandler: ((Any?, ApiError?)->())?)
}

class ApiServiceImp: ApiService {
    func getCountries(completionHandler: ((Any?, ApiError?)->())?) {
        Services.GetCountries { (result, error) in
            if error == nil {
                completionHandler!(result, nil)
            } else {
                completionHandler!(nil, error)
            }
        }.execute()
    }
    
    func getCities(completionHandler: ((Any?, ApiError?)->())?) {
        Services.GetCities { (result, error) in
            if error == nil {
                completionHandler!(result, nil)
            } else {
                completionHandler!(nil, error)
            }
        }.execute()
    }
    
    func getCity(_ cityName: String, completionHandler: ((Any?, ApiError?)->())?) {
        Services.GetCity(city: cityName) { (result, error) in
            if error == nil {
                completionHandler!(result, nil)
            } else {
                completionHandler!(nil, error)
            }
        }.execute()
    }
}

class ApiServiceMock: ApiService {
    func getCountries(completionHandler: ((Any?, ApiError?)->())?) {
        print("mock countries")
    }
    
    func getCities(completionHandler: ((Any?, ApiError?)->())?) {
        print("mock cities")
    }
    
    func getCity(_ cityName: String, completionHandler: ((Any?, ApiError?)->())?) {
        print("mock \(cityName)")
    }
}
