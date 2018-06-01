//
//  GlovoInitManager.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation

protocol InitDelegate: class {
    func onCountriesCompleted(result: Any?, error: ApiError?)
    func onCitiesCompleted(result: Any?)
    func onError(error: ApiError?)
}

class GlovoInitManager {
    
    weak var delegate: InitDelegate?
    let service: ApiService!
    
    var dispatchGroup: DispatchGroup = DispatchGroup()
    
    init(service: ApiService) {
        self.service = service
        self.dispatchGroup = DispatchGroup()
    }
    
    func initializeCountries(delegate: InitDelegate?) {
        self.delegate = delegate
        dispatchGroup.enter()
        service.getCountries() { (result, error) in
            self.dispatchGroup.leave()
            if error == nil {
                delegate?.onCountriesCompleted(result: result, error: nil)
                Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GlovoInitManager.initializeCities), userInfo: nil, repeats: false)
                self.initializeCities()
            } else {
                delegate?.onCountriesCompleted(result: nil, error: error)
            }
        }
    }
    
    @objc func initializeCities() {
        dispatchGroup.enter()
        service.getCities() { (result, error) in
            self.dispatchGroup.leave()
            if error == nil {
                self.dispatchGroup.notify(queue: DispatchQueue.main) {
                    self.delegate?.onCitiesCompleted(result: result)
                }
            } else {
                self.delegate?.onError(error: error)
            }
        }
    }
    
}

class Glovo {
    static var instance = Glovo()
    private init() {}
    var countries: [Country] = []
    var cities: [City] = []
}
