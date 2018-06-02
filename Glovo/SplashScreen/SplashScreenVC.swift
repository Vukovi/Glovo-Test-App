//
//  SplashScreenVC.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import UIKit
import SnapKit

class SplashScreenVC: UIViewController {
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "logo")
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = .clear
        return imgView
    }()
    
    var presenter: SplashScreenPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = SplashScreenPresenter(initManager: GlovoInitManager(service: Api.instance.getService()))
        presenter?.attachView(view: self)
        
        self.view.backgroundColor = .white
        self.view.addSubview(imageView)
        imageView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.callServer()
    }
    
}

extension SplashScreenVC: SplashScreenView {
    func onCompleted(result: Any) {
        if let array = result as? [NSDictionary] {
            for city in array {
                Glovo.instance.cities.append(City(result: city))
            }
        }
        let mainVC = MainVC()
        let window = UIApplication.shared.keyWindow!
        window.rootViewController = UINavigationController(rootViewController: mainVC)
        window.makeKeyAndVisible()
    }
    
    func onError(error: ApiError) {
        print(error)
    }
    
    
}
