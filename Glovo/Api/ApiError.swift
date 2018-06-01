//
//  ApiError.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation


public class ApiError {
    
    var action: String! = ""
    var code: String! = ""
    var message: String? = ""
    
    init() {}
    
    init(action: String?, code: String, message: String?) {
        self.action = action ?? ""
        self.code = code
        
        if let acn = action {
            self.action = acn
        }
        
        if let msg = message {
            self.message = msg
        }
    }
    
    public init(response: Any?) {
        guard let dict = response as? NSDictionary else {
            return
        }
        if let error: NSDictionary = dict["error"] as? NSDictionary {
            self.action = error["action"] as? String ?? nil
            self.code = error["code"] as? String ?? ""
            self.message = error["message"] as? String ?? ""
        }
    }
    
    public func isEmpty() -> Bool {
        return action == nil && code == nil && message == nil
    }
}
