//
//  SplashScreenPresenter.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation

class SplashScreenPresenter {
    
    weak var splashScreenView: SplashScreenView?
    private var initManager: GlovoInitManager?
    
    public init(initManager: GlovoInitManager) {
        self.initManager = initManager
    }
    
    public func callServer() {
        initManager?.initializeCountries(delegate: self)
    }
    
    public func attachView(view: SplashScreenView) {
        splashScreenView = view
    }
    
    func detachView() {
        splashScreenView = nil
    }
}

extension SplashScreenPresenter: InitDelegate {
    func onCountriesCompleted(result: Any?, error: ApiError?) {
        if error == nil {
            if let array = result as? [NSDictionary] {
                for country in array {
                    Glovo.instance.countries.append(Country(result: country))
                }
            }
        } else {
            onError(error: error)
        }
    }
    
    func onCitiesCompleted(result: Any?) {
        self.splashScreenView?.onCompleted(result: result!)
    }
    
    func onError(error: ApiError?) {
        self.splashScreenView?.onError(error: error!)
    }
    
    
}
