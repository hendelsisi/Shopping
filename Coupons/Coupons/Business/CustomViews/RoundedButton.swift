//
//  RoundedButton.swift
//  Coupons
//
//  Created by hend elsisi on 5/10/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit
import SVProgressHUD


protocol RoundedButtonDelegate {
    func updateToViewFrozen()
    func updateToInteractiveView()
    func couponStatusChanged(for id:String)
}

  class RoundedButton: UIButton,CouponStateDelegate,signUpRequest {
    func signUpdidSucceed() {
        self.showAlertonLogin()
    }
    
    func changeToFrozenView() {
        self.delegate?.updateToViewFrozen()
    }
    
    func changeToInteractiveView() {
        self.delegate?.updateToInteractiveView()
    }
    
    func needUpdateView(coup:Offer?){
        self.updateView(coup: coup)
    }
    
    func updateView(coupId:String){
        self.delegate?.couponStatusChanged(for: coupId)
    }
    
    var delegate:RoundedButtonDelegate?
    
       required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 10.0
    }
    
    func requestOffer(cont:WalletViewController,coup:Offer?){
         self.validateCoupon(coup: coup,cont:cont)
    }
    
    func requestOffer(cont:CouponDetailViewController,coup:Offer?){
        if self.isRegistered(){
            self.checkCoupAndShare(cont: cont,coup: coup)
        }else{
             self.goToSignUp(cont: cont)
        }
    }
    
     func checkCoupAndShare(cont:CouponDetailViewController,coup:Offer?){
        if CouponState.sharedInstance.isPurchasedCoup(selectedCoup:coup){
            self.validateCoupon(coup: coup,cont:cont)
        }
        else{
            self.resetSessionToken()
            self.goToShare(selectedCoup: coup, cont: cont)
        }
    }
    
    func resetSessionToken(){
        if UserDefaultsManager.instance.getObjectForKey("renewSession") != nil{
            FBRequstHandler.sharedInstance.logOut()
            UserDefaultsManager.instance.removeObject("renewSession")
        }
    }
    
    func showAlertonLogin() {
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("login msg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("Welcome Back !", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
    }
    
   func goToShare(selectedCoup:Offer?,cont:UIViewController?) {

    UIUtils.instance.showAlertwith(type: "share") { (accept) in
        if accept{
            CouponState.sharedInstance.delegate = self
            CouponState.sharedInstance.startShareCoup(selectedCoup: selectedCoup, cont: cont)
        }
    }
    }
    
    func updateView(coup:Offer?){
                if coup?.purchased != nil {
                    print("in wallet")
                    if coup?.purchased?.post_status == "inProcess" {
                        print("supposed")
                        self.setTitle(NSLocalizedString("redeemButtonVerify", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), for: .normal)
                    }
                    else if coup?.purchased?.post_status == "valid"{
                        self.setTitle(NSLocalizedString("Use In Stor", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), for: .normal)
                    }
                    else if coup?.purchased?.post_status == "check"{
                          self.setTitle(NSLocalizedString("checkOrder", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), for: .normal)
                    }
                }
                else{
                  self.setTitle(NSLocalizedString("redeemOffer", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), for: .normal)
        }
    }

    
     func isRegistered()->Bool{
    return !Utility.instance.isFirstTimeSignUp()
    }
    func goToSignUp(cont:CouponDetailViewController) {
        cont.performSegue(withIdentifier: "register", sender: nil)
    }
    
     func validateCoupon(coup:Offer?,cont:UIViewController?){
        
        if UserDefaultsManager.instance.getObjectForKey("CoupState") != nil{
            UserDefaultsManager.instance.removeObject("CoupState")
            NotificationManager.instance.decrementBadge()
             self.beginCheck(coup: coup)
        }
        else{
           
            if coup?.purchased?.post_status == "valid"{
                print("new method")
                cont?.performSegue(withIdentifier: "UseCode", sender: self)
            }
            else if coup?.purchased?.post_status == "inProcess" {
                UIUtils.instance.showAlertWithMsg(NSLocalizedString("inProccessMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("inProccessTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
            }
                
            else if coup?.purchased?.post_status == "check"{
                 NotificationManager.instance.decrementBadge()
                self.beginCheck(coup: coup)
            }
            
        }
    }
   
     func beginCheck(coup:Offer?){
        CouponState.sharedInstance.delegate = self
        CouponState.sharedInstance.verifyCouponForLastTime(coup: coup)
    }
    
//    func canRecieveCode(date:Date) -> Bool {
//        let now = Date()
//        var components: DateComponents = Calendar.current.dateComponents([Calendar.Component.minute], from: now, to: date)
//        let min = components.minute
//        if min! > 5 ||  min! < 0{
//            return true
//        }
//        else{
//            return false
//        }
//    }
    
     func freezeView(cont:UIViewController?){
        cont?.view.isUserInteractionEnabled = false
        SVProgressHUD.setContainerView(cont?.view)
        SVProgressHUD.show()
    }
     func freeView(cont:UIViewController?){
        cont?.view.isUserInteractionEnabled = true
        SVProgressHUD.dismiss()
    }
    
}


