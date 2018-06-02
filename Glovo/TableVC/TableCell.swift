//
//  TableCell.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/2/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell, CellData {

    private let lbl = UILabel()
    var data: String? {
        didSet {
            lbl.text = data
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(lbl)
        lbl.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
    }
}
