//
//  GlovoConfigurationBuilder.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation

class GlovoBuilder {
    var baseUrl: String?
    var countriesEndpoint: String?
    var citiesEndpoint: String?
    var mocked: Bool?
    
    typealias BuilderClosure = (GlovoBuilder) -> ()
    
    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}

class GlovoConfiguration {
    var baseUrl: String
    var countriesEndpoint: String
    var citiesEndpoint: String
    var mocked: Bool

    init?(builder: GlovoBuilder) {
        if let baseUrl = builder.baseUrl, let countriesEndpoint = builder.countriesEndpoint, let citiesEndpoint = builder.citiesEndpoint, let mocked = builder.mocked {
            self.baseUrl = baseUrl
            self.countriesEndpoint = countriesEndpoint
            self.citiesEndpoint = citiesEndpoint
            self.mocked = mocked
        } else {
            return nil
        }
    }
    
    func getBaseUrl() -> String {
        return baseUrl
    }
    
    func getCountriesUrl() -> String {
        return getBaseUrl() + countriesEndpoint
    }
    
    func getCitiesUrl() -> String {
        return getBaseUrl() + citiesEndpoint
    }
    
    func isMocked() -> Bool {
        return mocked
    }
    
}
