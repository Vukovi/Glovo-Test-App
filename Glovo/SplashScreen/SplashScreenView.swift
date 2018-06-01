//
//  SplashScreenView.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation

protocol SplashScreenView: NSObjectProtocol {
    func onCompleted(result: Any)
    func onError(error: ApiError)
}
