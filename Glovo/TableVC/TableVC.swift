//
//  TableVC.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/2/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import UIKit

protocol ReturnDelegate: NSObjectProtocol {
    func goBack()
    func chosenCity(city: City)
}

class TableVC: UIViewController {
    
    weak var delegate: ReturnDelegate?
    let sectionHeaderHeight: CGFloat = 25
    var data = [CountryCodes: [String]]()
    
    lazy var navigationView : NavigationBarView = {
        let navBar : NavigationBarView = NavigationBarView()
        navBar.navigationTitle.text = "Glovo Working Areas"
        return navBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.cellReuseIdentifier())
        return tableView
    }()
    
    func sortData() {
        for key in Glovo.instance.countries {
            let cities: [City] = Glovo.instance.cities.filter({
                $0.country == key.country
            })
            let value: [String] = cities.map {
                $0.name
            }
            data.updateValue(value, forKey: key.country)
        }
    }
    
    @objc func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
        delegate?.goBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(navigationView)
        navigationView.snp.remakeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        navigationView.leftNavigationButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.view.addSubview(tableView)
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        sortData()
    }
}


extension TableVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contryCode: CountryCodes = Glovo.instance.countries[section].country
        let tableData: [String] = data[contryCode]!
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let contryCode: CountryCodes = Glovo.instance.countries[section].country
        let tableData: [String] = data[contryCode]!
        if tableData.count > 0 {
            return sectionHeaderHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        view.backgroundColor = UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: sectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        let countryName: String = Glovo.instance.countries[section].name
        label.text = countryName
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.cellReuseIdentifier(), for: indexPath) as! TableCell
        let contryCode: CountryCodes = Glovo.instance.countries[indexPath.section].country
        let tableData: String = data[contryCode]![indexPath.row]
        cell.data = tableData
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: TableCell = tableView.cellForRow(at: indexPath) as! TableCell
        let city: City = Glovo.instance.cities.filter { $0.name == cell.data }.first!
        _ = self.navigationController?.popViewController(animated: true)
        delegate?.chosenCity(city: city)
    }
}
