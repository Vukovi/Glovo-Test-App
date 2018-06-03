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
import CoreLocation

class MainVC: UIViewController {
    
    var presenter: MainPresenter?
    var currentLocation: CLLocation?
    var zoom: Double = 15
    var polygons = [GMSPolygon]()
    var notWorkingArea: Bool?
    var markers = [GMSMarker]()
    
    lazy var locationManager: CLLocationManager = {
        let locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        return locManager
    }()
    
    lazy var map: GMSMapView = {
        let mapView = GMSMapView()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        mapView.mapType = GMSMapViewType.normal
        mapView.settings.compassButton = true
        return mapView
    }()
    
    lazy var cityName: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.text = "Sorry, no info at the moment"
        view.textAlignment = .center
        return view
    }()
    
    lazy var cityCurrency: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.text = "Sorry, no info at the moment"
        view.textAlignment = .center
        return view
    }()
    
    lazy var cityTimeZone: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.text = "Sorry, no info at the moment"
        view.textAlignment = .center
        return view
    }()
    
    lazy var cityState: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.text = "Sorry, no info at the moment"
        view.textAlignment = .center
        return view
    }()

    
    func setUIElements() {
        map.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(self.view.frame.height * 2 / 3)
        }
        
        cityName.snp.remakeConstraints { (make) in
            make.top.equalTo(map.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Double(Double(self.view.frame.height) - Double(self.view.frame.height * 2 / 3))/4)
        }
        
        cityCurrency.snp.remakeConstraints { (make) in
            make.top.equalTo(cityName.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Double(Double(self.view.frame.height) - Double(self.view.frame.height * 2 / 3))/4)
        }
        
        cityTimeZone.snp.remakeConstraints { (make) in
            make.top.equalTo(cityCurrency.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Double(Double(self.view.frame.height) - Double(self.view.frame.height * 2 / 3))/4)
        }
        
        cityState.snp.remakeConstraints { (make) in
            make.top.equalTo(cityTimeZone.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(service: Api.instance.getService())
        presenter?.attachView(view: self)
        
        self.view.addSubview(map)
        self.view.addSubview(cityName)
        self.view.addSubview(cityCurrency)
        self.view.addSubview(cityTimeZone)
        self.view.addSubview(cityState)
        
        setUIElements()
        currentLocation = locationManager.location
        configureWorkingArea()
        configureMap()
        if !locatedInWorkingArea() {
            notWorkingArea = true
            showTable()
        } else {
            let city = findCity()
            presenter?.cityDetail(cityName: city.code)
        }
    }
    
}





extension MainVC: MainView {
    func getCity(details: CityDetails) {
        cityName.text = details.name
        cityCurrency.text = details.currency
        cityTimeZone.text = details.time_zone
        cityState.text = Glovo.instance.countries.filter({
            $0.country == details.country
        }).first?.name
        
    }
    
    func showError(error: ApiError) {
        print(error)
    }
    
    func showTable() {
        let tableVC = TableVC()
        tableVC.delegate = self
        self.navigationController?.pushViewController(tableVC, animated: true)
    }
}




extension MainVC: ReturnDelegate {
    func chosenCity(city: City) {
        let areas = city.working_area
        let encodedPath = areas[areas.count/2]
        let path = GMSPath(fromEncodedPath: encodedPath)
        let location = path?.coordinate(at: path!.count() - 1)
        let camera = GMSCameraPosition.camera(withTarget: location!, zoom: 11)
        map.animate(to: camera)
        presenter?.cityDetail(cityName: city.code)
    }
    
    func goBack() {
        let actionSheet = UIAlertController(title: "Location Usage", message: "Provide us your location", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (_ ) in
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
            self.notWorkingArea = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_ ) in
            self.notWorkingArea = nil
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(editAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}





extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            self.currentLocation = currentLocation
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorized && notWorkingArea == nil {
            notWorkingArea = true
            showTable()
        }
    }
}





extension MainVC: GMSMapViewDelegate {
    
    func configureMap() {
        if let currentLocation = currentLocation {
            let position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.map = map
            marker.userData = ["MyLocation":true]
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: Float(zoom))
            self.map.camera = camera
        }
    }
    
    func configureWorkingArea() {
        for area in Glovo.instance.cities {
            var cityPaths = [GMSPath]()
            for encodedPath in area.working_area {
                var oldPolygon: GMSPolygon?
                if encodedPath != "" {
                    let polygon = GMSPolygon()
                    polygon.path = GMSPath(fromEncodedPath: encodedPath)
                    if #available(iOS 10.0, *) {
                        polygon.fillColor = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 0.2)
                    }
                    if let intersection = areaIntersecting(newPath: polygon.path!, oldPath: oldPolygon?.path) {
                        polygon.holes = [intersection]
                    }
                    if !areaOverlaping(newPath: polygon.path!, oldPath: oldPolygon?.path) {
                        polygon.map = map
                    }
                    oldPolygon = polygon
                    polygons.append(polygon)
                    cityPaths.append(polygon.path!)
                }
            }
            let path = cityPaths[cityPaths.count/2]
            let location = path.coordinate(at: path.count() - 1)
            let marker = GMSMarker(position: location)
            marker.title = area.name
            marker.snippet = area.code
            marker.icon = GMSMarker.markerImage(with: .blue)
            marker.map = map
            markers.append(marker)
        }
    }
    
    
    func areaOverlaping(newPath: GMSPath, oldPath: GMSPath?) -> Bool {
        var overlaps = false
        if let old = oldPath {
            for i in 0..<newPath.count() {
                if GMSGeometryContainsLocation(newPath.coordinate(at: i), old, true) {
                    overlaps = true
                }
            }
        }
        return overlaps
    }
    
    func areaIntersecting(newPath: GMSPath, oldPath: GMSPath?) -> GMSPath? {
        var path: GMSMutablePath?
        if let old = oldPath {
            path = GMSMutablePath()
            for i in 0..<newPath.count() {
                if GMSGeometryIsLocationOnPath(newPath.coordinate(at: i), old, true) {
                    path?.add(newPath.coordinate(at: i))
                }
            }
        }
        return path
    }
    
    func locatedInWorkingArea() -> Bool {
        var located = false
        for polygon in polygons {
            if let coordinate = currentLocation?.coordinate, GMSGeometryContainsLocation(coordinate, polygon.path!, true) {
                located = true
                break
            }
        }
        return located
    }
    
    func findCity(coordinateCity: CLLocationCoordinate2D? = nil) -> City {
        let current: CLLocationCoordinate2D? = coordinateCity ?? currentLocation?.coordinate
        var city: City!
        for town in Glovo.instance.cities{
            for encodedPath in town.working_area {
                let polygon = GMSPolygon()
                polygon.path = GMSPath(fromEncodedPath: encodedPath)
                if let coordinate = current, GMSGeometryContainsLocation(coordinate, polygon.path!, true) {
                    city = town
                    break
                }
            }
        }
        
        return city
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print(position.zoom)
        if position.zoom < 10 {
            markers.map { $0.opacity = 1 }
        } else {
            markers.map { $0.opacity = 0 }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let cityName = marker.title
        let city: City = Glovo.instance.cities.filter { $0.name == cityName }.first!
        chosenCity(city: city)
        return true
    }


    
}

