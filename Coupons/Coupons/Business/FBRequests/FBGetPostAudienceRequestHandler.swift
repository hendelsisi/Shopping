//
//  FBGetPostAudience.swift
//  Coupons
//
//  Created by hend elsisi on 5/31/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import SwiftyJSON



class FBGetPostAudienceRequestHandler:FBOperationsHandler{
    
    func performFbOperation(successfulOperation: @escaping (Bool) -> Void) {
         if Utility.instance.handleNetwork() {
        self.getPrivacyRequest(id: self.postId) { (finished) in
            if finished{
                successfulOperation(true)
            }
        }
        }
    }
    
    var postId:String
    
    init(pId:String){
        self.postId = pId
    }
    
//    func checkPostPrivacy(id:String,block:@escaping (Bool)->Void)  {
//      //  self.delegate?.prepareUIforFBRequest()
//        self.getPrivacyRequest(id: id) { (finished) in
//          //  self.delegate?.updateViewAfterFBRequest()
//            if finished{
//                block(true)
//            }
//        }
//    }
    
    //Mark: - make sure the published post is public to allow the users friends know about the promotion
    func getPrivacyRequest(id:String,handler:@escaping (Bool)->Void){
        print("here getPrivacyRequest")
        let request = GraphRequest(graphPath: "/\(id)",
            parameters: ["fields": "privacy"],
            httpMethod: .GET)
        request.start { httpResponse, result in
            self.handleGetUserPostRequest(result: result, handler: handler)
        }
    }
    
    func handleGetUserPostRequest(result:GraphRequestResult<GraphRequest>,handler:@escaping (Bool)->Void){
        switch result {
        case .success(let response):
            print("Graph Request Succeeded: \(response)")
            let raw = response as GraphRequest.Response
            
            if self.isPrivatePost(response: raw) {
                //handler(true,"private")
                UIUtils.instance.showAlertWithMsg( NSLocalizedString("privatePostMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title:NSLocalizedString("privatePostTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
            }
            else{
                handler(true)
            }
        case .failed(let error):
            print("Graph Request Failed: \(error)")
            print(error.localizedDescription)
            if error.localizedDescription.range(of: "8") != nil {
                print("not found")
               // handler(true,"deleted")
                UIUtils.instance.showAlertWithMsg( NSLocalizedString("privatePostMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title:NSLocalizedString("privatePostTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
            }
            else{
                print("got results")
              //  handler(false,"")
                 UIUtils.instance.showAlertWithMsg(NSLocalizedString("errorShareMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("errorShareTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
            }
        }
    }
    
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
    
    
//    func checkAfterShare(pid: String,sale:Offer?){
//        if Utility.instance.handleNetwork() {
//            FBRequstHandler.sharedInstance.delegate = self
//            FBRequstHandler.sharedInstance.checkPostPrivacy(id: pid,block: {finish,privacy in
//                if finish{
//                    // add to cart and change the button title
//                    print(privacy)
//                    if privacy == "private" || privacy == "deleted"{
//
//                        UIUtils.instance.showAlertWithMsg( NSLocalizedString("privatePostMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title:NSLocalizedString("privatePostTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
//
//                    }else{
//                        //add local notification
//                        NotificationManager.instance.addNotif( withTitle: sale?.coup_store, checkId: pid)
//                        self.addCoupAndAlert(coup: sale, pid: pid)
//                    }
//                }
//                else{
//                    UIUtils.instance.showAlertWithMsg(NSLocalizedString("errorShareMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("errorShareTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
//                }
//            })
//        }
//    }
}
