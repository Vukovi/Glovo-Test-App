//
//  ApiMethod.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation
import Alamofire

class ApiMethod {
    
    var apiConfiguration: GlovoConfiguration?
    var headers = ["Accept": "application/json", "Content-Type":"application/json; charset=utf-8"]
    var parameters: [String: Any]? = [String: Any]()
    
    init(headers: [String: String], parameters: [String: Any]?) {
        self.parameters = parameters
        self.apiConfiguration = Api.instance.getConfiguration()
        for (key, value) in headers {
            self.headers.updateValue(value, forKey: key)
        }
    }
    
    func endpoint() -> String  {
        preconditionFailure("This method must be overridden")
    }
    
    func httpMethod() -> HTTPMethod {
        return .get
    }
    
    func onSuccess(result: Any) {
        preconditionFailure("This method must be overridden")
    }
    
    func onFailure(error: ApiError) {
        preconditionFailure("This method must be overridden")
    }
    
    func execute() {
        Api.instance.alamofireManager?.request(endpoint(), method: httpMethod(), parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { responseResult in

            switch responseResult.result {
            case .success(let value):
                self.onSuccess(result: value)
                break
            case .failure(let error):
                let apiError = ApiError(response: responseResult)
                apiError.message = error.localizedDescription
                self.onFailure(error: apiError)
                break
            }
        }
    }
    
    func getConfiguration() -> GlovoConfiguration {
        return apiConfiguration!
    }
    
}
