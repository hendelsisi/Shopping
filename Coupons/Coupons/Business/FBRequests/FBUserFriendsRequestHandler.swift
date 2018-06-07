//
//  FBFriendsRequestHandler.swift
//  Coupons
//
//  Created by hend elsisi on 5/31/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import SwiftyJSON

class FBUserFriendsRequestHandler:FBOperationsHandler
{
    func performFbOperation(successfulOperation: @escaping (Bool) -> Void) {
        self.checkAndHandleUserAudience { (canReachPeople) in
            if canReachPeople{
                //post
                print("ready to post")
                successfulOperation(true)
            }
        }
    }
    
     static let instance = FBUserFriendsRequestHandler()
    func getFbUserFriends(successfulOperation: @escaping (Bool) -> Void) {
            // self.checkUserFriendsBeforeShare(sale: sale)
//        self.checkAndHandleUserAudience { (canReachPeople) in
//            if canReachPeople{
//                //post
//                print("ready to post")
//                successfulOperation(true)
//            }
//        }
    }
    
    // one time request
    func checkAndHandleUserAudience(getFriends:@escaping (Bool)->Void)  {
        if UserDefaultsManager.instance.getObjectForKey("getUserFriendsRequestDate") == nil{
            self.handleUserFriends(get: getFriends)
        }
        else{
            self.preventUserFromRepeatedRequestError(getFriends: getFriends)
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
                    self.fewFBFriendsAlert()
                }
            }
            else{
                UIUtils.instance.showAlertWithMsg(NSLocalizedString("network msg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: "")
                //error reapeated request might happen so store key value to check it in the second time request
                UserDefaultsManager.instance.saveObject(Date() as AnyObject, key: "getUserFriendsRequestDate")
            }
        }
    }
    
    func fewFBFriendsAlert()  {
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("fewFriends", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: "")
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
    
    func showAlertForRepeatedRequestCase(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("rpeatRequestMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("rpeatRequestTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
    func preventUserFromRepeatedRequestError(getFriends:@escaping (Bool)->Void){
        let lastTimeRequest:Date = UserDefaultsManager.instance.getObjectForKey("getUserFriendsRequestDate") as! Date
        if self.canRepeatRequest(lastDate: lastTimeRequest){
            //remove key
            UserDefaultsManager.instance.removeObject("getUserFriendsRequestDate")
            //request again
            self.handleUserFriends(get: getFriends)
        }
        else{
            self.showAlertForRepeatedRequestCase()
        }
    }
    
    private func getUserFriendsRequest(block: @escaping (Bool,Int) -> Void)  {
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
        let frndjson = JSON.init(response.dictionaryValue!["friends"]!)
        let summary = frndjson.dictionaryValue["summary"]
        return (summary?["total_count"].intValue)!
    }
  
}
