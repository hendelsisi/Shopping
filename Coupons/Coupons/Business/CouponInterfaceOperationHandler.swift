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

var sharedInstance:CouponInterfaceOperationHandler?

class CouponInterfaceOperationHandler: NSObject,ShareManagerDelegate {
    func fbShareDidSucceed() {
          self.delegate?.needUpdateView(coup: self.coupon)
        //handle successful share delegate
        NotificationManager.instance.addNotif( withTitle: self.coupon?.coup_store, checkId: (self.coupon?.purchased?.facebook_post)!)
        self.addCoupAndAlert(coup: self.coupon, pid: (self.coupon?.purchased?.facebook_post)!)
    }
    
//    func updateControllerViewBeforRequest() {
//        self.delegate?.changeToFrozenView()
//    }
//
//    func updateControllerViewAfterRequest() {
//        self.delegate?.changeToInteractiveView()
//    }
    
//    func fbShareDidSucceed(sale:Offer?) {
//
//    }
    
//    func fbShareDidFailed() {
//        //
//    }
    
    var delegate:CouponStateDelegate?
    var currentViewController: UIViewController{
        get{
            return (UIApplication.shared.delegate?.window??.rootViewController)!
        }
    }
   // make init constructor ////////////////HERE !!!!!!!!!!!!!!!!!!!!!
   // var notifiedCoupon:Offer?
  //  var purchasedCoupon:Offer?
    var coupon:Offer?
    var facebookPostId:String?
    init(pid:String){
        self.facebookPostId = pid
    }
//    init(purchasedCoupon:Offer?){
//        self.purchasedCoupon = purchasedCoupon
//    }
    
    init(coupon:Offer?){
        self.coupon = coupon
    }
    
//   override init(){
//        self.facebookPostId = ""
//    }
    
   // one time call
     func verifyCouponForLastTime(readyforUpdate:@escaping (Bool)->Void){
        if Utility.instance.handleNetwork(){
         //  self.delegate?.changeToFrozenView()
            self.updateToViewFrozen()
            self.verifyMyPurchasedCoup(coup: self.coupon) { (success, postExist) in
              //  self.delegate?.changeToInteractiveView()
                self.updateToInteractiveView()
                if success && postExist{
                    DataBaseManager.instance.editCouponToRecivedCodeState(id: (self.coupon?.purchased?.facebook_post)!, dbedit: { (success) in
                        if success{
                           // self.delegate?.needUpdateView(coup: coup)
                            readyforUpdate(true)
                            UIUtils.instance.showAlertWithMsg(NSLocalizedString("successMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("successTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
                        }
                    })
                }
                else if success && !postExist{
                    self.removeCoupon(coup: self.coupon, delete: { (success) in
                        if success{
                             readyforUpdate(true)
                            UIUtils.instance.showAlertwith(type: "postNotFound", accept: { (accept) in
                            })
                        }
                    })
                }else{
                    //remove it to avoid repeated request error
                    self.removeCoupon(coup: self.coupon, delete: { (success) in
                        if success{
                             readyforUpdate(true)
                          UIUtils.instance.showAlertWithMsg(NSLocalizedString("failedPostMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("failedPostTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
                        }
                    })
                }
            }
        }
    }
    
   func updateToViewFrozen() {
        currentViewController.view.isUserInteractionEnabled = false
        SVProgressHUD.show()
    }
    
    func updateToInteractiveView() {
        currentViewController.view.isUserInteractionEnabled = true
        SVProgressHUD.dismiss()
    }
    
    
    func removeCoupon(coup:Offer?,delete:(Bool)->Void){
        DataBaseManager.instance.deleteCouponfromCart(id: (coup?.purchased?.facebook_post)!, dbDelete: { (success) in
            if success{
                CartGround.instance.decrementDigit()
              //  self.delegate?.needUpdateView(coup: coup)
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
    
    func startShareCoup(){
        ShareManager.instace.delegate = self
      //  ShareManager.instace.fbShare(selectedCoup)
        ShareManager.instace.fbShare(self.coupon)

    }
    
    func handleCoupStateAfterNotification(){
        DataBaseManager.instance.modifyCoupStateAfterNotification(id: self.facebookPostId!) { (success) in
                    if !success{
                        UserDefaultsManager.instance.saveObject("check" as AnyObject, key: "CoupState")
                    }
                    else{
                      self.delegate?.updateView(coupId: self.facebookPostId!)
                    }
                }
    }
        
// static let sharedInstance = CouponInterfaceOperationHandler()
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
    
   class func isPurchasedCoup(selectedCoup:Offer?)->Bool{
            return selectedCoup?.purchased != nil
        }
    
    func addCoupAndAlert(coup:Offer?,pid:String )  {
        //        DataBaseManager.instance.addValidShareState(coup: coup,postId:pid ) { (finish) in
        //            if finish{
        //               self.delegate?.fbShareDidSucceed(sale: coup)
        //                self.addLocalNotification(coup, postId: pid)
        //
        //                 UIUtils.instance.showAlertWithMsg(NSLocalizedString("aftershareMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("aftershareTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
        //            }
        //            else{
        //        UIUtils.instance.showAlertWithMsg(NSLocalizedString("errorShareMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("errorShareTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
        //            }
        //        }
    }
 
}
