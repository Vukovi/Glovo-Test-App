//
//  MainView.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation

protocol MainView: NSObjectProtocol {
    func getCity(details: CityDetails)
    func showError(error: ApiError)
}
