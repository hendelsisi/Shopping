//
//  CustomBarItem.swift
//  Coupons
//
//  Created by hend elsisi on 5/24/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

protocol CustomBarItemDelegate {
    func menuButtonDidClicked()
}

class CustomBarItem: UIView {

    var delegate:CustomBarItemDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let button:UIButton = UIButton.init(type: .custom)
        button.frame = frame
        button.setImage(UIImage(named: "coupon_screen_icon"), for: .normal)
        button.addTarget(self, action: Selector("ViewMenu:"), for: .touchUpInside)
        
        addSubview(button)
        
    }
    
    @objc func ViewMenu(_ sender: Any?){
        self.delegate?.menuButtonDidClicked()
    }

}
