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

public final class FBRequstHandler: NSObject {
    
 static let sharedInstance = FBRequstHandler()
     var loginManager:LoginManager = LoginManager()
    var offer:Offer?
    var ref:CouponDetailViewController?
      var delegate: FBRequstHandlerDelegate?
    
   func shareToFB(coup: Offer?, atControl control: CouponDetailViewController?) {
    self.ref = control
    self.offer = coup
    
    if self.isInValidAccessToken() {
            print("nil token")
            startLoginAndShare(ref: control,sale:coup)
        }
        else{
            print("not nil")
            if UserDefaultsManager.instance.getObjectForKey("CanShare") == nil{
                self.checkUserAudience{ (canShare) in
                    if canShare{
                        //post
                        self.askPermission(sale: coup)
                    }
                }
            }
            else{
                if self.validateUserSharingAbility(cont: control){
                    //post
                    print("this case")
                    self.askPermission(sale: coup)
                }
            }
        }
    }
    
    func isInValidAccessToken()->Bool{
        return AccessToken.current == nil  || (AccessToken.current?.expirationDate)! < Date()
    }
    
    func logOut()  {
                LoginManager.shared.logOut()
                UserDefaultsManager.instance.removeObject("CanShare")
    }
    
     func shareFBDialog(view:CouponDetailViewController?,offer:Offer?){
        let url = URL(string: (offer?.coup_link_Url)!)
        let content = LinkShareContent(url: url!)
        self.showShareDialog(content, mode:.automatic,view: view) { (postSucceed,pID) in
            if postSucceed{
                self.delegate?.sharingFacebookdidSucceeded(pid: pID,offer:offer )
            }
            else{
                self.delegate?.sharingFacebookdidFailed()
            }
        }
    }
    
    func checkPostPrivacy(id:String,block:@escaping (Bool,String)->Void)  {
        self.delegate?.prepareUIforFBRequest()
            self.getPrivacyRequest(id: id) { (finished,type) in
                 self.delegate?.updateViewAfterFBRequest()
                if finished{
                    block(true,type)
                }
                else{
                      block(false,"")
                }
            }
    }
    
     func getPrivacyRequest(id:String,handler:@escaping (Bool,String)->Void){
       print("here getPrivacyRequest")
        let request = GraphRequest(graphPath: "/\(id)",
                                   parameters: ["fields": "privacy"],
                                   httpMethod: .GET)
        request.start { httpResponse, result in
         self.handleGetUserPostRequest(result: result, handler: handler)
        }
    }
    
     func handleGetUserPostRequest(result:GraphRequestResult<GraphRequest>,handler:@escaping (Bool,String)->Void){
        switch result {
        case .success(let response):
            print("Graph Request Succeeded: \(response)")
            let raw = response as GraphRequest.Response
            
            if self.isPrivatePost(response: raw) {
                handler(true,"private")
            }
            else{
                handler(true,"valid")
            }
        case .failed(let error):
            print("Graph Request Failed: \(error)")
            print(error.localizedDescription)
            if error.localizedDescription.range(of: "8") != nil {
                print("not found")
                handler(true,"deleted")
            }
            else{
                 print("got results")
                handler(false,"")
            }
        }
    }
    
     func isPrivatePost(response:GraphRequest.Response)->Bool{
        let json = JSON.init(response.dictionaryValue!)
        let privacy:JSON? = json["privacy"]
        let audinecePost = privacy?.dictionaryValue["value"]!
     //   print(privacy?.dictionaryValue["value"]!)
        if audinecePost == "SELF" || audinecePost == "CUSTOM"{
           return true
        }
        else{
            return false
        }
    }
    //Mark: - share facebook dialog
    func showShareDialog<C: ContentProtocol>(_ content:C, mode: ShareDialogMode = .automatic,view:CouponDetailViewController?,handler:@escaping (Bool,String)->Void) {
        let dialog = ShareDialog(content: content)
        dialog.presentingViewController = view
        dialog.mode = mode
        
        dialog.completion = { result in
            // Handle share results
            switch result {
            case .success(let shareResult):
                
                let post = shareResult as? PostSharingResult
                if post.debugDescription.contains("postId"){
                    let postId:String = (post?.postId)!
                     let pid = self.getValidationKey(pid: postId)
                    handler(true,pid)
                }
                else{
                      UIUtils.instance.showAlertWithMsg(NSLocalizedString("shareCanceledMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("shareCanceledTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
                     handler(false,"")
                }
               
            case .failed(let error):
                
                 UIUtils.instance.showAlertWithMsg(NSLocalizedString("shareFailedMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("shareFailedTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
                handler(false,"")
                
                print("\(error.localizedDescription)")
            case .cancelled:
               
                  UIUtils.instance.showAlertWithMsg(NSLocalizedString("shareCanceledMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("shareCanceledTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
                 handler(false,"")
            }
            print("got \(result)")
        }
        do {
            try dialog.show()
        } catch (let error) {
            print("Failed to present share dialog with error \(error)")
        }
    }


    private func getValidationKey(pid:String)->String{
        var key:String = (AccessToken.current?.userId)!
       print("key \(key)")
       key.append("_")
        key.append(pid)
        print("search for \(key)")
       return key
    }
    
    //MARK: - share offer to facebook
   private func postOffer(_ coup: Offer?,atControl control: CouponDetailViewController?)  {
    if (AccessToken.current?.grantedPermissions?.contains("publish_actions"))!{
        
        self.shareFBDialog(view: control, offer: coup)
        }
        else{
            loginManager.logIn(publishPermissions: [.publishActions], viewController: control) { (result) in
                self.loginManagerPublishDidComplete(result,view: control,sale:coup)
            }
        }
    }
    
    func validateUserSharingAbility(cont:CouponDetailViewController?)->Bool  {
        let canShare:String = (UserDefaultsManager.instance.getObjectForKey("CanShare")  as? String)!
        if canShare == "true"{
            return true
        }else{
            fewFBFriendsAlert(view:cont)
            return false
        }
    }
    // one time request
   func checkUserAudience(getFriends:@escaping (Bool)->Void)  {
    if UserDefaultsManager.instance.getObjectForKey("sharePostDate") == nil{
     self.handleUserFriends(get: getFriends)
    }
    else{
        let lastTimeRequest:Date = UserDefaultsManager.instance.getObjectForKey("sharePostDate") as! Date
        if self.canRepeatRequest(lastDate: lastTimeRequest){
            //remove key
            UserDefaultsManager.instance.removeObject("sharePostDate")
            //request again
              self.handleUserFriends(get: getFriends)
        }
        else{
            UIUtils.instance.showAlertWithMsg(NSLocalizedString("rpeatRequestMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("rpeatRequestTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
        }
    }
    }
    
    func handleUserFriends(get:@escaping (Bool)->Void){
        self.getUserFriendsRequest{ (success, number) in
            if success{
                if ( number > 10){
                    UserDefaultsManager.instance.saveObject("true" as AnyObject, key: "CanShare")
                    get(true)
                }
                else{
                    UserDefaultsManager.instance.saveObject("false" as AnyObject, key: "CanShare")
                    UIUtils.instance.showAlertWithMsg(NSLocalizedString("fewFriends", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: "")
                }
            }
            else{
                UIUtils.instance.showAlertWithMsg(NSLocalizedString("network msg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: "")
                //error reapeated request might happen
                UserDefaultsManager.instance.saveObject(Date() as AnyObject, key: "sharePostDate")
            }
        }
    }
    //handle repeated graph request failure
    func canRepeatRequest(lastDate:Date)->Bool{
                let now = Date()
                var components: DateComponents = Calendar.current.dateComponents([Calendar.Component.minute], from: now, to: lastDate)
                let hr = components.hour
                if hr! > 3 ||  hr! < 0{
                    return true
                }
                else{
                    return false
                }
    }
    
    func askPermission(sale:Offer?)  {
        self.postOffer(self.offer, atControl: self.ref)
    }
    
    func fewFBFriendsAlert(view:CouponDetailViewController?)  {
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("fewFriends", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: "")
    }
   
   func getUserFriendsRequest(block: @escaping (Bool,Int) -> Void)  {
    let request = GraphRequest(graphPath: "/me",
                               parameters: ["fields": "friends"],
                               httpMethod: .GET)
    request.start { httpResponse, result in
      self.handleGetFriendsRequest(result: result, block: block)
    }
    }
    
    func handleGetFriendsRequest(result:GraphRequestResult<GraphRequest>,block: @escaping (Bool,Int) -> Void){
     var num:Int = 0
    switch result {
    case .success(let response):
        print("Graph Request Succeeded: \(response)")
        num = self.getNumOfFriends(response: response)
        block(true,num)
        print("count friends:\(num)")
    case .failed(let error):
        print("Graph Request Failed: \(error)")
        block(false,0)
    }
    }
    
     func getNumOfFriends(response:GraphRequest.Response)->Int{
    //    let myid = response.dictionaryValue!["id"]
     //   print("my id\(myid)")
        
        let frndjson = JSON.init(response.dictionaryValue!["friends"]!)
        let summary = frndjson.dictionaryValue["summary"]
       return (summary?["total_count"].intValue)!
    }
    
    func startLoginAndShare(ref:CouponDetailViewController?,sale:Offer?)  {
  
        loginManager = LoginManager.shared
        loginManager.logIn(readPermissions: [.publicProfile,.userFriends,.email,.userPosts], viewController: ref) { result in
            self.loginManagerDidComplete(result:result,view: ref,sale:sale)
        }
    }
    
    func loginManagerDidComplete(result: LoginResult,view:CouponDetailViewController?,sale:Offer?)  {
        switch result {
        case .cancelled:
            UIUtils.instance.showAlertWithMsg(NSLocalizedString("cancelLoginMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("cancelLoginTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
        case .failed(let error):
            UIUtils.instance.showAlertWithMsg(NSLocalizedString("failedLoginMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("failedLoginTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
            print("\(error)")
        case .success(let grantedPermissions, _ , _):
            print( "Login succeeded with granted permissions: \(grantedPermissions)")
       self.beginToShare(view: view, sale: sale)
        }
    }
    
     func beginToShare(view:CouponDetailViewController?,sale:Offer?){
        self.delegate?.prepareUIforFBRequest()
        self.checkUserAudience { (canReachPeople) in
            self.delegate?.updateViewAfterFBRequest()
            if canReachPeople{
                //post
                print("ready to post")
                UIUtils.instance.showAlertwith(type: "fbPermission", accept: { (accept) in
                    if accept{
                        FBRequstHandler.sharedInstance.askPermission(sale: sale)
                    }
                })
            }
        }
    }
    
    func loginManagerPublishDidComplete(_ result: LoginResult,view:CouponDetailViewController?,sale:Offer?) {
        switch result {
        case .cancelled:
            UIUtils.instance.showAlertWithMsg(NSLocalizedString("cancelPublishMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("cancelPublisTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
        case .failed(let error):
            UIUtils.instance.showAlertWithMsg(NSLocalizedString("failedPublisMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("failedPublisTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
            print("\(error)")
        case .success(let grantedPermissions,_,_):
            print( "Login succeeded with new granted permissions: \(grantedPermissions)")
             self.shareFBDialog(view: view, offer: sale)
    }
    }
    
}
