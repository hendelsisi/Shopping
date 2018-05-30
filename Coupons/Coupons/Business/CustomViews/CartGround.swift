//
//  CartGround.swift
//  Coupons
//
//  Created by hend elsisi on 5/15/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit
import M13BadgeView

protocol CartGroundDelegate:NSObjectProtocol {
    func cartButtonDidClicked()
    func refreshView()
}

class CartGround: UIView {
    static let instance = CartGround.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
   
    var notificationDigit:Int8 {
        get{
            return self.getNotifNumber()
        }
        set{
          UserDefaultsManager.instance.saveObject(newValue as AnyObject, key: "notifNumber")
        }
    }
    
    var lib : M13BadgeView?
    weak var delegate:CartGroundDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let button:UIButton = UIButton.init(type: .custom)
        button.frame = frame
        button.setImage(UIImage(named: "Coupons_screen_wallet_icon"), for: .normal)
        button.addTarget(self, action: Selector("ViewCart:"), for: .touchUpInside)

       addSubview(button)
         lib = M13BadgeView.init(frame: CGRect.init(x: -15, y: -15, width: 20, height: 20))
        
        addSubview(lib!)
        lib?.text = String(notificationDigit)
        if Utility.instance.isEnglishSystem(){
        lib?.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight
        }
        else if(notificationDigit != 0){
            lib?.text = String(notificationDigit).replacedEnglishDigitsWithArabic
            lib?.horizontalAlignment = M13BadgeViewHorizontalAlignmentLeft
        }
        lib?.hidesWhenZero = true
    }
    
    @objc func ViewCart(_ sender: Any?){
       self.delegate?.cartButtonDidClicked()
    }
    
    func getNotifNumber()->Int8{
        if UserDefaultsManager.instance.getObjectForKey("notifNumber") == nil {
             return 0
        }
        else{
            return UserDefaultsManager.instance.getObjectForKey("notifNumber") as! Int8
        }
    }
    
    func incrementDigit(){
        print("incrementDigit")
        notificationDigit = notificationDigit + 1
        
        if Utility.instance.isEnglishSystem(){
            lib?.text = String(notificationDigit)
             lib?.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight
        }
        else{
            lib?.text = String(notificationDigit).replacedEnglishDigitsWithArabic
            lib?.horizontalAlignment = M13BadgeViewHorizontalAlignmentLeft
        }
         lib?.hidesWhenZero = true
        self.delegate?.refreshView()
    }
    
    func decrementDigit(){
        print("decrementDigit")
        if notificationDigit != 0{
            notificationDigit = notificationDigit - 1
            
            if Utility.instance.isEnglishSystem(){
                lib?.text = String(notificationDigit)
                lib?.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight
            }
            else if (notificationDigit != 0){
                lib?.text = String(notificationDigit).replacedEnglishDigitsWithArabic
                lib?.horizontalAlignment = M13BadgeViewHorizontalAlignmentLeft
            }
            lib?.hidesWhenZero = true
            self.delegate?.refreshView()
        }
    }
    
    
    func reset(){
        notificationDigit = 0
        lib?.text = String(notificationDigit)
        lib?.hidesWhenZero = true
         self.delegate?.refreshView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
}
}
