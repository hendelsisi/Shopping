//
//  FBRequstHandler+Login.swift
//  Coupons
//
//  Created by hend elsisi on 5/31/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import SwiftyJSON

extension FBRequstHandler{
     func startLoginAndShare(sale:Offer?)  {
        loginManager = LoginManager.sharedLogin
        loginManager.logIn(readPermissions: [.publicProfile,.userFriends,.email,.userPosts], viewController: self.currentViewController) { result in
            self.loginManagerDidComplete(result:result,sale:sale)
        }
    }
    
     func loginManagerDidComplete(result: LoginResult,sale:Offer?)  {
        print("will not print this until login")
        switch result {
        case .cancelled:
            self.showCancelLoginAlert()
        case .failed(let error):
            self.showFailedLoginAlert()
            print("\(error)")
        case .success(let grantedPermissions, _ , _):
            print( "Login succeeded with granted permissions: \(grantedPermissions)")
            self.checkUserFriendsBeforeShare(sale: sale)
        }
    }
    
     func loginManagerPublishDidComplete(_ result: LoginResult,sale:Offer?) {
        switch result {
        case .cancelled:
            self.showCancelPublishAlert()
        case .failed(let error):
            self.showCancelPublishAlert()
            print("\(error)")
        case .success(let grantedPermissions,_,_):
            print( "Login succeeded with new granted permissions: \(grantedPermissions)")
            self.shareFBDialog(offer: sale)
        }
    }
    
     func isInValidAccessToken()->Bool{
        return AccessToken.current == nil  || (AccessToken.current?.expirationDate)! < Date()
    }
    
    //Mark: - make log out to reset the facebook user session
    func logOut()  {
        LoginManager.sharedLogin.logOut()
        UserDefaultsManager.instance.removeObject("CanShare")
    }
}
//Mark: - FBRequstHandler + ShareDialog
extension FBRequstHandler{
    //Mark: - share facebook dialog
    private  func showShareDialog<C: ContentProtocol>(_ content:C, mode: ShareDialogMode = .automatic,handler:@escaping (Bool,String)->Void) {
        let dialog = ShareDialog(content: content)
        dialog.presentingViewController = self.currentViewController
        dialog.mode = mode
        
        dialog.completion = { result in
            // Handle share results
            switch result {
            case .success(let shareResult):
                
                let post = shareResult as? PostSharingResult
                self.handleSuccessfulFBDialogReturn(post: post, handler: handler)
                
            case .failed(let error):
                
                self.showFailureFbShareAlert()
                handler(false,"")
                
                print("\(error.localizedDescription)")
            case .cancelled:
                self.showCanceledFbShareAlert()
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
    
    func managePermissionAndShare(sale:Offer?)  {
        self.postOffer(sale)
    }
    
    func shareFBDialog(offer:Offer?){
        let url = URL(string: (offer?.coup_link_Url)!)
        let content = LinkShareContent(url: url!)
        
        self.showShareDialog(content, mode:.automatic) { (postSucceed,pID) in
            if postSucceed{
                self.delegate?.sharingFacebookdidSucceeded(pid: pID,offer:offer )
            }
            else{
                self.delegate?.sharingFacebookdidFailed()
            }
        }
    }
    
     func handleSuccessfulFBDialogReturn(post:PostSharingResult?,handler:@escaping (Bool,String)->Void){
        if post.debugDescription.contains("postId"){
            let postId:String = (post?.postId)!
            let pid = self.getValidationKey(pid: postId)
            handler(true,pid)
        }
        else{
            UIUtils.instance.showAlertWithMsg(NSLocalizedString("shareCanceledMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("shareCanceledTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
            handler(false,"")
        }
    }
    //extension on string
     func getValidationKey(pid:String)->String{
        var key:String = (AccessToken.current?.userId)!
        print("key \(key)")
        key.append("_")
        key.append(pid)
        print("search for \(key)")
        return key
    }
    
    //MARK: - share offer to facebook
     func postOffer(_ coup: Offer?)  {
        if (AccessToken.current?.grantedPermissions?.contains("publish_actions"))!{
            self.shareFBDialog(offer: coup)
        }
        else{
            loginManager.logIn(publishPermissions: [.publishActions], viewController: self.currentViewController) { (result) in
                self.loginManagerPublishDidComplete(result,sale:coup)
            }
        }
    }
}
//Mark: - FBRequstHandler + get post setting request
extension FBRequstHandler{
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
    
    //Mark: - make sure the published post is public to allow the users friends know about the promotion
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
    //extension same file + json
     func isPrivatePost(response:GraphRequest.Response)->Bool{
        let json = JSON.init(response.dictionaryValue!)
        let privacy:JSON? = json["privacy"]
        let audinecePost = privacy?.dictionaryValue["value"]!
        if audinecePost == "SELF" || audinecePost == "CUSTOM"{
            return true
        }
        else{
            return false
        }
    }
}
