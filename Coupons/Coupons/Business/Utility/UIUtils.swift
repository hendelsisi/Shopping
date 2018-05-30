//
//  UIUtils.swift
//  LoopVideo
//
//  Created by Minas Kamel on 9/19/16.
//  Copyright © 2016 Minas Kamel. All rights reserved.
//

import Foundation
import UIKit



public final class UIUtils {

    static let instance = UIUtils()
    
  //  var sharedCoupon:Offer?
    
    
//    func showShareAlert(_ msg:String,title:String,ref: CouponDetailViewController?,sharedCoupon:Offer){
//
//        let alertController = UIAlertController(title: "", message: "Help your friends to reach the offer to gain more points and win the gift for free !!", preferredStyle: .alert)
//
//        let action3 = UIAlertAction(title: "Share", style: .default) { (action:UIAlertAction) in
//
//
//        }
//        
//        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
//
//        }
//
//        alertController.addAction(action3)
//        alertController.addAction(action2)
//
//        ref?.present(alertController, animated: true, completion: nil)
//    }
    
    func showAlertwith(type:String,accept:@escaping (Bool)->Void)  {
        var msg:String = ""
        var title:String = ""
        var alertController:UIAlertController = UIAlertController()
        
        if type == "share" {
            
            msg = NSLocalizedString("shareMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            title = NSLocalizedString("shareTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            
             alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action3 = UIAlertAction(title: NSLocalizedString("shareButton", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .default) { (action:UIAlertAction) in
                
                accept(true)

            }
            
            let action2 = UIAlertAction(title: NSLocalizedString("cancelButton", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .cancel) { (action:UIAlertAction) in
                
            }
            
            alertController.addAction(action3)
            alertController.addAction(action2)
            
            
        }
        
        else if type == "fbPermission"{
            msg = NSLocalizedString("permissionMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            title = NSLocalizedString("permissionTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            
             alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action3 = UIAlertAction(title: NSLocalizedString("acceptButton", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .default) { (action:UIAlertAction) in
                
                 accept(true)
            }
            
            let action2 = UIAlertAction(title: NSLocalizedString("cancelButton", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .cancel) { (action:UIAlertAction) in
                
            }
            
            alertController.addAction(action3)
            alertController.addAction(action2)
            
        }
        else if type == "logOut"{
            msg = NSLocalizedString("logOutMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            title = NSLocalizedString("logOutTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            
             alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action3 = UIAlertAction(title: NSLocalizedString("logOutButton", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .default) { (action:UIAlertAction) in
              // 
                 accept(true)
            }
            
            let action2 = UIAlertAction(title: NSLocalizedString("cancelButton", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .cancel) { (action:UIAlertAction) in
                 accept(false)
            }
            
            alertController.addAction(action3)
            alertController.addAction(action2)
            
        }
        
        else if type == "postNotFound"{
            
            msg = NSLocalizedString("hiddenPostMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            title = NSLocalizedString("hiddenPostTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            
             alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action3 = UIAlertAction(title: NSLocalizedString("okButton", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .default) { (action:UIAlertAction) in
                print("delete now...")
              
                 accept(true)
            }
            alertController.addAction(action3)
        }
        
        else if type == "notify"{
            msg = NSLocalizedString("notifyMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            title = ""
            
            alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action3 = UIAlertAction(title: NSLocalizedString("notifyBtn", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .default) { (action:UIAlertAction) in
                
                accept(true)
            }
            let action2 = UIAlertAction(title: NSLocalizedString("cancelButton", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .cancel) { (action:UIAlertAction) in
                accept(false)
            }
            alertController.addAction(action3)
            alertController.addAction(action2)
        }
        else if type == "userDelete"{
            msg = NSLocalizedString("removeMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            title = NSLocalizedString("removeTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: "")
            
            alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action3 = UIAlertAction(title: NSLocalizedString("removeBtn", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .default) { (action:UIAlertAction) in
                
                accept(true)
            }
            let action2 = UIAlertAction(title: NSLocalizedString("cancelButton", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), style: .cancel) { (action:UIAlertAction) in
                accept(false)
            }
            alertController.addAction(action3)
            alertController.addAction(action2)
        }
        
        (UIApplication.shared.delegate?.window??.rootViewController)!.present(alertController, animated: true, completion: nil)
    }
    
//    func notificaionAlert(sharePost:CouponFacebookShareState,fromView:UIViewController,post_id:String)  {
//        //
//        var title:String = ""
//        var msg:String = ""
//        var reactButtonTitle:String = ""
//        if sharePost == .deleted {
//            //
//            title = "Oopps !!"
//            msg = "Coupon App can't find a public facebook post about the purchased offer"
//            // ok button
//            reactButtonTitle = "Ok"
//            //delete from core data
//        }
//        else if sharePost == .undetermined {
//            //
//            msg = "Hooray!! your voucher is ready to use availble at wallet section"
//             //thnx alot
//             reactButtonTitle = "thnx,alot"
//            //remain in core data
//        }
//        else if sharePost == .valid {
//            //
//            title = "Congratulation !!"
//            msg = "Finally, you got the voucher , when ready to use it go to wallet section "
//            //thnx alot
//             reactButtonTitle = "thnx,alot"
//        }
//        else if sharePost == .privatePost {
//            //
//            msg = "Coupon App can't find a public facebook post about the selected offer,Please make sure the facebook post is public"
//            //change privacy if fbook app exist
//            
//             if (UIApplication.shared.canOpenURL(URL(string:"fb://")!))
//             {
//                reactButtonTitle = "check my privacy setting"
//            }
//            else{
//                 reactButtonTitle = "Ok"
//            }
//        }
//        
//        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
//        let oKButton = UIAlertAction(title: reactButtonTitle, style: .default, handler:
//        {(_ action: UIAlertAction?) -> Void in
//            //Handle no, thanks button
//            if sharePost == .deleted {
//                DataBaseManager.instance.deleteCouponfromCart(id: post_id)
//            }
//            else if sharePost == .privatePost{
//                
//            }
//        })
//        
//        if sharePost == .privatePost{
//            let recheck = UIAlertAction(title: "I changed my privacy setting", style: .default, handler:
//            {(_ action: UIAlertAction?) -> Void in
//                //Handle no, thanks button
//                ShareManager.instace.postValidateState(postID: post_id, alertType: { (finish, state) in
//                    if finish{
//                        // show alert
//                        UIUtils.instance.notificaionAlert(sharePost: state, fromView: fromView, post_id: post_id)
//                    }
//                })
//            })
//             alert.addAction(recheck)
//        }
//        
//        alert.addAction(oKButton)
//        fromView.present(alert, animated: true) {() -> Void in }
//    }
    
    
//    func walletCodeAlert(sharePost:CouponFacebookShareState,fromView:UIViewController,pid:String){
//        var title:String = ""
//        var msg:String = ""
//         var reactButtonTitle:String = ""
//        
//        if sharePost == .privatePost {
//            //
//             title = "Sorry"
//            msg = "Coupon App can't find a public facebook post about the purchased offer,Please make sure the facebook post is public then click check again after finish."
//            //change privacy if fbook app exist
//            if (UIApplication.shared.canOpenURL(URL(string:"fb://")!))
//            {
//                reactButtonTitle = "check my privacy setting"
//            }
//            else{
//                reactButtonTitle = "Ok"
//            }
//            print("private")
//        }
//        
//         if sharePost == .deleted {
//            // remove from core data
//             print("deleted")
//        }
//    
//        if sharePost != .valid{
//            
//            if sharePost == .undetermined{
//                msg = "This means you are in the store and need the code to discount at hte casher"
//                reactButtonTitle = "Ready"
//            }
//            
//            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
//            let oKButton = UIAlertAction(title: reactButtonTitle, style: .default, handler:
//            {(_ action: UIAlertAction?) -> Void in
//                //Handle no, thanks button
//                if sharePost == .undetermined {
//                print("wut undetermined")
//                    let availableNetwork: Bool = Reachability.checkRechability()
//                    if availableNetwork  {
//                         print("network")
//                        //dismiss the alert
//                        ShareManager.instace.postValidateState(postID: pid, alertType: { (finish, state) in
//                            if finish{
//                                // show alert
//                                UIUtils.instance.notificaionAlert(sharePost: state, fromView: fromView, post_id: pid)
//                            }
//                        })
//                        
//                    } else {
//                        print("not connect")
//                       UIUtils.instance.showAlertWithMsg(NSLocalizedString("network msg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: "", ref: fromView)
//                    }
//                }
//            })
//            if  sharePost == .undetermined  {
//                print("undetermined")
//                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler:
//                {(_ action: UIAlertAction?) -> Void in
//                })
//                
//                alert.addAction(cancel)
//            }
//            alert.addAction(oKButton)
//            fromView.present(alert, animated: true) {() -> Void in }
//        }
//        else{
//            
//        }
//    }
//    
    func showCartAlert(_ref: CouponDetailViewController?){
        
        let alertController = UIAlertController(title: "Great job", message: "The server will prepare the discount Code for you and will Add the coupon to your Cart", preferredStyle: .alert)
        
        let action3 = UIAlertAction(title: "Cheers", style: .destructive) { (action:UIAlertAction) in
            print("You've pressed the destructive");
          
            _ref?.performSegue(withIdentifier: "ShowCart", sender: nil)
        }
        alertController.addAction(action3)
        _ref?.present(alertController, animated: true, completion: nil)
    }
    
    
    func goToShare() {
        
       // delegate?.shareOffer()
       // ShareManager.instace.delegate = ref
       // ShareManager.instace.fbShare(coupon, atControl: ref)
    }
    
    func showAlertWithMsg(_ msg:String,title:String){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let oKButton = UIAlertAction(title: NSLocalizedString("Ok", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), style: .default, handler:
        {(_ action: UIAlertAction?) -> Void in
            //Handle no, thanks button
        })
        alert.addAction(oKButton)
        (UIApplication.shared.delegate?.window??.rootViewController)!.present(alert, animated: true) {() -> Void in }
    }
    
    func showAlertView(_ title: String, message: String){
//        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
//        alertView.show()
    }
}
