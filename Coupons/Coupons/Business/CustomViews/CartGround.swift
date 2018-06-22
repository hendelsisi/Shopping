//
//  CartGround.swift
//  Coupons
//
//  Created by hend elsisi on 5/15/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit
//import M13BadgeView

protocol CartGroundDelegate:NSObjectProtocol {
    func cartButtonDidClicked()
  //  func refreshView()
}

class CartGround: UIView {
    
    let notificationButton = SSBadgeButton()
    
    static let instance = CartGround.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
   
    var notificationDigit:Int = 0 {
        didSet{
          UserDefaultsManager.instance.saveObject(notificationDigit as AnyObject, key: "notifNumber")
            if notificationDigit == 0{
                notificationButton.badgeLabel.isHidden = true
            }
        }
    }
    
   // var lib : M13BadgeView?
    weak var delegate:CartGroundDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.notificationDigit = self.getNotifNumber()
        notificationButton.frame = frame
        notificationButton.setImage(UIImage(named: "Coupons_screen_wallet_icon"), for: .normal)
        notificationButton.addTarget(self, action: Selector("ViewCart:"), for: .touchUpInside)

       addSubview(notificationButton)
        
        if  notificationDigit != 0 {
            if Utility.instance.isEnglishSystem(){
                notificationButton.badge = String(notificationDigit)
            }
            else{
                notificationButton.badge = String(notificationDigit).replacedEnglishDigitsWithArabic
            }
        }
    }
    
    @objc func ViewCart(_ sender: Any?){
       self.delegate?.cartButtonDidClicked()
    }
    
   public func getNotifNumber()->Int{
        if UserDefaultsManager.instance.getObjectForKey("notifNumber") == nil {
             return 0
        }
        else{
            return UserDefaultsManager.instance.getObjectForKey("notifNumber") as! Int
        }
    }
    
    func incrementDigit(){
        print("incrementDigit")
        notificationDigit = notificationDigit + 1
        
        if Utility.instance.isEnglishSystem(){
             notificationButton.badge = String(notificationDigit)
//             lib?.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight
        }
        else{
            notificationButton.badge = String(notificationDigit).replacedEnglishDigitsWithArabic
//            lib?.horizontalAlignment = M13BadgeViewHorizontalAlignmentLeft
        }
        
    //   self.delegate?.refreshView()
    }
    
//    func decrementDigit(){
//        print("decrementDigit")
//        if notificationDigit != 0{
//            notificationDigit = notificationDigit - 1
//
//            if Utility.instance.isEnglishSystem(){
//                notificationButton.badge = String(notificationDigit)
////                lib?.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight
//            }
//            else if (notificationDigit != 0){
//                notificationButton.badge = String(notificationDigit).replacedEnglishDigitsWithArabic
////                lib?.horizontalAlignment = M13BadgeViewHorizontalAlignmentLeft
//            }
//
////            lib?.hidesWhenZero = true
//
//           // self.delegate?.refreshView()
//        }
//    }
    
    
    func reset(){
        notificationDigit = 0
       // notificationButton.badge = String(notificationDigit)
//        lib?.hidesWhenZero = true
        // self.delegate?.refreshView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
}
}
