//
//  CouponVerification.swift
//  Coupons
//
//  Created by hend elsisi on 5/10/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol CouponStateDelegate {
    func changeToFrozenView()
    func changeToInteractiveView()
    func needUpdateView(coup:Offer?)
     func updateView(coupId:String)
}

 class CouponState: NSObject,ShareManagerDelegate {
    func updateControllerViewBeforRequest() {
        self.delegate?.changeToFrozenView()
    }
    
    func updateControllerViewAfterRequest() {
        self.delegate?.changeToInteractiveView()
    }
    
    func fbShareDidSucceed(sale:Offer?) {
        self.delegate?.needUpdateView(coup: sale)
    }
    
    func fbShareDidFailed() {
        //
    }
    
    var delegate:CouponStateDelegate?
   
   
   // one time call
    func verifyCouponForLastTime(coup:Offer?){
        if Utility.instance.handleNetwork(){
           self.delegate?.changeToFrozenView()
            self.verifyMyPurchasedCoup(coup: coup) { (success, postExist) in
                self.delegate?.changeToInteractiveView()
                if success && postExist{
                    DataBaseManager.instance.editCouponToRecivedCodeState(id: (coup?.purchased?.facebook_post)!, dbedit: { (success) in
                        if success{
                            self.delegate?.needUpdateView(coup: coup)
                            UIUtils.instance.showAlertWithMsg(NSLocalizedString("successMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("successTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
                        }
                    })
                }
                else if success && !postExist{
                    self.removeCouponAndUpdateView(coup: coup, delete: { (success) in
                        if success{
                            UIUtils.instance.showAlertwith(type: "postNotFound", accept: { (accept) in
                            })
                        }
                    })
                }else{
                    //remove it to avoid repeated request error
                    self.removeCouponAndUpdateView(coup: coup, delete: { (success) in
                        if success{
                          UIUtils.instance.showAlertWithMsg(NSLocalizedString("failedPostMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("failedPostTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
                        }
                    })
                }
            }
        }
    }
    
    
    func removeCouponAndUpdateView(coup:Offer?,delete:(Bool)->Void){
        DataBaseManager.instance.deleteCouponfromCart(id: (coup?.purchased?.facebook_post)!, dbDelete: { (success) in
            if success{
              //  CartGround.instance.decrementDigit()
                self.delegate?.needUpdateView(coup: coup)
               delete(true)
            }
        })
    }
    
    func handleUserDeleteCoupon(coupItem:MyWallet?){
        let notifId = coupItem?.facebook_post
        DataBaseManager.instance.deleteCouponfromCart(id: (coupItem?.facebook_post)!, dbDelete: { (finish) in
            //remove notification with id
            NotificationManager.instance.removeLocalNotification(id: notifId!)
        })
    }
    
    func startShareCoup(selectedCoup:Offer?,cont:UIViewController?){
        ShareManager.instace.delegate = self
        ShareManager.instace.fbShare(selectedCoup, atControl: cont as! CouponDetailViewController)
    }
    
    func handleCoupStateAfterNotification(coupShereId:String){
                DataBaseManager.instance.modifyCoupStateAfterNotification(id: coupShereId) { (success) in
                    if !success{
                        UserDefaultsManager.instance.saveObject("check" as AnyObject, key: "CoupState")
                    }
                    else{
                      self.delegate?.updateView(coupId: coupShereId)
                    }
                }
    }
        
 static let sharedInstance = CouponState()
    var deleteOrderid:String?
    
    func verifyMyPurchasedCoup(coup:Offer?,getSetting:@escaping (Bool,Bool)->Void){
        
            FBRequstHandler.sharedInstance.checkPostPrivacy(id: (coup?.purchased?.facebook_post)!) { (finished, setting) in
                if finished{
                    print("finish")
                    if setting == "valid"{
                        getSetting(true,true)
                    }
                        
                    else{
                        getSetting(true,false)
                    }
                }
                else{
                    getSetting(false,false)
                    //error occur try again will make repeat request error
                }
            }
    }
    
    func isPurchasedCoup(selectedCoup:Offer?)->Bool{
            return selectedCoup?.purchased != nil
        }
 
}
