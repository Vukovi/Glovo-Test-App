//
//  MainVC.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/1/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SnapKit

class MainVC: UIViewController {
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var zoom: Double = 15
    
    lazy var map: GMSMapView = {
       let mapView = GMSMapView()
        return mapView
    }()
    
    lazy var addressView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var apartmentView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("DONE", for: .normal)
        btn.addTarget(self, action: #selector(MainVC.buttonPressed), for: .touchUpInside)
        btn.backgroundColor = .yellow
        return btn
    }()
    
    @objc func buttonPressed() {
        print("btn pressed!!!")
    }
    
    func setUIElements() {
        map.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(self.view.frame.height * 2 / 3)
        }
        
        addressView.snp.remakeConstraints { (make) in
            make.top.equalTo(map.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Double(Double(self.view.frame.height) - Double(self.view.frame.height * 2 / 3))/3)
        }
        
        apartmentView.snp.remakeConstraints { (make) in
            make.top.equalTo(addressView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Double(Double(self.view.frame.height) - Double(self.view.frame.height * 2 / 3))/3)
        }
        
        button.snp.remakeConstraints { (make) in
            make.top.equalTo(apartmentView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(map)
        self.view.addSubview(addressView)
        self.view.addSubview(apartmentView)
        self.view.addSubview(button)
        
        setUIElements()
    }
    
}
