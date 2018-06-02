//
//  CellData.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/2/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation

public protocol CellData {
    associatedtype DataType
    var data: DataType? {get set}
}

extension CellData {
    public static func cellReuseIdentifier() -> String {
        return String(describing:self)
    }
}
