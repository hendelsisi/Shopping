//
//  FBUserLogin.swift
//  Coupons
//
//  Created by hend elsisi on 5/31/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import UIKit

//protocol FBUserLoginDelegate {
//  func fbLoginDidSucceed()
//}

class FBUserLoginRequestHandler{

    static let instance = FBUserLoginRequestHandler()
    var loginManager:LoginManager = LoginManager()
    var currentViewController: UIViewController{
        get{
            return (UIApplication.shared.delegate?.window??.rootViewController)!
        }
    }
    //var delegate:FBUserLoginDelegate?
    
    func performFbLogin(successfulOperation:@escaping (Bool) -> Void) {
        // startLoginAndShare(sale:coup)
        loginManager = LoginManager.sharedLogin
        loginManager.logIn(readPermissions: [.publicProfile,.userFriends,.email,.userPosts], viewController: self.currentViewController) { result in
            self.loginManagerDidComplete(result: result,success:successfulOperation)
        }
    }
    
    func loginManagerDidComplete(result: LoginResult,success:(Bool) -> Void)  {
        switch result {
        case .cancelled:
            FBUserLoginRequestHandler.showCancelLoginAlert()
        case .failed(let error):
            FBUserLoginRequestHandler.showFailedLoginAlert()
            print("\(error)")
        case .success(let grantedPermissions, _ , _):
            print( "Login succeeded with granted permissions: \(grantedPermissions)")
            success(true)
        }
    }
    
    func logInWithPublishPermission(success:@escaping (Bool)->Void)  {
        if (AccessToken.current?.grantedPermissions?.contains("publish_actions"))!{
          //  self.shareFBDialog(offer: coup)
            success(true)
        }
        else{
            loginManager.logIn(publishPermissions: [.publishActions], viewController: self.currentViewController) { (result) in
                self.loginManagerPublishDidComplete(result, success: success)
            }
        }
    }
    
    func loginManagerPublishDidComplete(_ result: LoginResult,success:@escaping (Bool)->Void) {
        switch result {
        case .cancelled:
            FBUserLoginRequestHandler.showCancelPublishAlert()
        case .failed(let error):
            FBUserLoginRequestHandler.showCancelPublishAlert()
            print("\(error)")
        case .success(let grantedPermissions,_,_):
            print( "Login succeeded with new granted permissions: \(grantedPermissions)")
            //  self.shareFBDialog(offer: sale)
            success(true)
        }
    }
  
}

extension FBUserLoginRequestHandler {
  class func isInValidAccessToken()->Bool{
        return AccessToken.current == nil  || (AccessToken.current?.expirationDate)! < Date()
    }
    
   class func showCancelLoginAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("cancelLoginMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("cancelLoginTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
   class func showFailedLoginAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("failedLoginMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("failedLoginTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
    
   class func showCancelPublishAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("cancelPublishMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("cancelPublisTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
}
