//
//  NavigationBarView.swift
//  Glovo
//
//  Created by Vuk Knežević on 6/2/18.
//  Copyright © 2018 Vuk Knežević. All rights reserved.
//

import UIKit
import SnapKit

class NavigationBarView: UIControl {
    
    lazy var leftNavigationButton : UIButton = {
        var btn: UIButton = UIButton()
        btn.setImage(UIImage(named: "backarrow"), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    lazy var navigationTitle : UILabel = {
        var lbl: UILabel = UILabel()
        lbl.textColor = .black
        lbl.font.withSize(14)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .yellow
        
        self.addSubview(leftNavigationButton)
        self.addSubview(navigationTitle)
        
        navigationTitle.snp.remakeConstraints {(make) -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
        }
        
        leftNavigationButton.snp.remakeConstraints {(make) -> Void in
            make.centerY.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
