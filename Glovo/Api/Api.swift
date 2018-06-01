//
//  Api.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import Foundation
import Alamofire

class Api {
    
    static let instance = Api()
    
    var glovoConfiguration: GlovoConfiguration?
    var service: ApiService?
    var alamofireManager: Alamofire.SessionManager?
    
    private init() {}
    
    func initialize(glovoConfiguration: GlovoConfiguration) {
        self.glovoConfiguration = glovoConfiguration
        
        if glovoConfiguration.isMocked() {
            setupMockService()
        } else {
            setupWebService()
        }
        
        setupHttpClient()
    }
    
    func setupMockService() {
        service = ApiServiceMock()
    }
    
    func setupWebService() {
        service = ApiServiceImp()
    }
    
    func setupHttpClient() {
        let configuration = URLSessionConfiguration.default
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    func getHttpClient() -> Alamofire.SessionManager {
        return alamofireManager!
    }
    
    func getService() -> ApiService {
        return service!
    }
    
    func getConfiguration() -> GlovoConfiguration {
        return glovoConfiguration!
    }
}
