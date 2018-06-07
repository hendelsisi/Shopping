//
//  FBRequstHandler.swift
//  Coupons
//
//  Created by hend elsisi on 5/6/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import SwiftyJSON
import SVProgressHUD

protocol FBRequstHandlerDelegate {
    func sharingFacebookdidSucceeded(pid:String,offer:Offer?)
    func sharingFacebookdidFailed()
    func prepareUIforFBRequest()
    func updateViewAfterFBRequest()
}

 class FBRequstHandler: NSObject {
    
 static let sharedInstance = FBRequstHandler()
     var loginManager:LoginManager = LoginManager()
    // var offer:Offer?
     var delegate: FBRequstHandlerDelegate?
    
    var currentViewController: UIViewController{
        get{
            return (UIApplication.shared.delegate?.window??.rootViewController)!
        }
    }
    
    //Mark: - share to facebook the requested coupon
   func shareToFB(coup: Offer?) {
  //  self.offer = coup
    if self.isInValidAccessToken() {
            print("nil token")
            startLoginAndShare(sale:coup)
        }
        else{
            print("not nil")
     self.requestUserFriendsAndShare(coup: coup)
        }
    }
    
}
