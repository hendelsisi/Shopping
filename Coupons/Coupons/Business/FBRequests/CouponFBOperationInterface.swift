//
//  CouponFBOperationInterface.swift
//  Coupons
//
//  Created by hend elsisi on 5/31/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol CouponFBOperationInterfaceDelegate {
    func fbSharingDidSucceed()
    func fbSharingDidFailed()
}

class CouponFBOperationInterface{
  
    static let instance = CouponFBOperationInterface()
    var currentViewController: UIViewController{
        get{
            return (UIApplication.shared.delegate?.window??.rootViewController)!
        }
    }
    var delegate: CouponFBOperationInterfaceDelegate?
    var fbOperation: FBOperationsHandler?
    
    //Mark: - share to facebook the requested coupon
    func shareOfferOnFacebookUserWall(coup: Offer?) {
        self.beforeSharingAction { (successfulUserAccount) in
            if successfulUserAccount{
                self.sharingAction(coup: coup, success: { (successfulShare, postId) in
                    if successfulShare{
                        self.afterSharingAction(id: postId, success: { (publicPost) in
                            if publicPost{
                                self.delegate?.fbSharingDidSucceed()
                            }
                            else{
                                self.delegate?.fbSharingDidFailed()
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    //----------------------------------------------------------------
    
    func updateToViewFrozen() {
        currentViewController.view.isUserInteractionEnabled = false
        SVProgressHUD.show()
    }
    
    func updateToInteractiveView() {
        currentViewController.view.isUserInteractionEnabled = true
        SVProgressHUD.dismiss()
    }
    
    //------------------------------------------------------------------
    //3 main methods
    
    func beforeSharingAction(success:@escaping(Bool)->Void){
        self.loginFbAction { (successfulLogin) in
            if successfulLogin{
                self.checkUserAudience(success: { (hasManyFriends) in
                    if hasManyFriends{
                        success(true)
                    }
                })
            }
        }
    }
    
    func sharingAction(coup: Offer?,success:@escaping(Bool,String)->Void){
        self.addPublishPermission { (publichPermissionGranted) in
            if publichPermissionGranted{
                FBShareDialog.instance.performFbShare(offer: coup, success: { (successfulShare, pId) in
                    if successfulShare{
                        success(true,pId)
                    }})
            }
        }
    }
    
    func afterSharingAction(id:String,success:@escaping(Bool)->Void){
        self.fbOperation = FBGetPostAudienceRequestHandler.init(pId: id)
        self.updateToViewFrozen()
        self.fbOperation?.performFbOperation(successfulOperation: { (publicPost) in
            self.updateToInteractiveView()
            if publicPost{
                success(true)
                print("public post")
            }})
    }
    // ------------------------------------------------
    
    func askPermissionAlert(acceptPublish:@escaping (Bool)->Void){
        UIUtils.instance.showAlertwith(type: "fbPermission", accept: { (accept) in
            if accept{
                acceptPublish(true)
            }
        })
    }
    
    func loginFbAction(success:@escaping(Bool)->Void){
        if FBUserLoginRequestHandler.isInValidAccessToken(){
            FBUserLoginRequestHandler.instance.performFbLogin(successfulOperation: { (loginSucceeded) in
                if loginSucceeded{
                    success(true)
                }
            })
        }else{
            success(true)
        }
    }
    
    func checkUserAudience(success:@escaping(Bool)->Void){
        self.updateToViewFrozen()
        self.fbOperation = FBUserFriendsRequestHandler.instance
        self.fbOperation?.performFbOperation(successfulOperation: { (canShare) in
            self.updateToInteractiveView()
            if canShare{
                success(true)
            }
        })
    }
    
    func addPublishPermission(success:@escaping(Bool)->Void){
        self.askPermissionAlert(acceptPublish: { (acceptPublish) in
            if acceptPublish{
                FBUserLoginRequestHandler.instance.logInWithPublishPermission(success: { (loginSuccessful) in
                    if loginSuccessful{
                        success(true)
                    }
                })
            }
        })
    }
    //-----------------------------------------------------
    
  
}
