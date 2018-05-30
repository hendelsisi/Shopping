//
//  MenuItemGround.swift
//  Coupons
//
//  Created by hend elsisi on 5/23/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class ItemAnimation: NSObject {
static let instance = ItemAnimation()
   
    func animate(view:UIView) {
        
        var angle:CGFloat = 0.0
        if Utility.instance.isEnglishSystem(){
            angle = .pi / 2
            //right one
        }
        else{
            angle = .pi / 2
        }
        
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            view.transform = CGAffineTransform(rotationAngle: angle)
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
    
    
    func undoButtonRotation(view:UIView) {
        
        var angle:CGFloat = 0.0
        if Utility.instance.isEnglishSystem(){
            angle = .pi / 180
        }
        else{
            angle = .pi / 360
        }
        
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            view.transform = CGAffineTransform(rotationAngle: angle)
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
}
