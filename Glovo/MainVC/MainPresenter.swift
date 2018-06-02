//
//  MainPresenter.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation

class MainPresenter {
    
    weak var mainView: MainView?
    private var service: ApiService?
    
    public init(service: ApiService) {
        self.service = service
    }
    
    public func cityDetail(cityName: String) {
        service?.getCity(cityName, completionHandler: { (result, error) in
            if error == nil {
                if let dict = result as? NSDictionary {
                    let cityDetail = CityDetails(result: dict)
                    self.mainView?.getCity(details: cityDetail)
                }
            } else {
                self.mainView?.showError(error: error!)
            }
        })
    }
    
    public func attachView(view: MainView) {
        mainView = view
    }
    
    func detachView() {
        mainView = nil
    }
}
