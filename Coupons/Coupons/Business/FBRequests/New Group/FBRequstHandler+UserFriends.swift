//
//  FBRequstHandler+UserFriends.swift
//  Coupons
//
//  Created by hend elsisi on 5/31/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import SwiftyJSON

extension FBRequstHandler{
    //Mark: - check user friends to allow user share case he has many fb friends
      func validateUserSharingAbility()->Bool  {
        let canShare:String = (UserDefaultsManager.instance.getObjectForKey("CanShare")  as? String)!
        if canShare == "true"{
            return true
        }else{
            fewFBFriendsAlert()
            return false
        }
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
    
     func requestUserFriendsAndShare(coup: Offer?){
        //store if user have many friends in user defaults to make the request only one time and to allow only users with many friends to get the promotion
        if UserDefaultsManager.instance.getObjectForKey("CanShare") == nil{
            self.checkAndHandleUserAudience{ (canShare) in
                if canShare{
                    //start to post on facebook
                    self.managePermissionAndShare(sale: coup)
                }
            }
        }
        else{
            if self.validateUserSharingAbility(){
                //start to post on facebook
                print("this case")
                self.managePermissionAndShare(sale: coup)
            }
        }
    }
    
     func checkUserFriendsBeforeShare(sale:Offer?){
        self.delegate?.prepareUIforFBRequest()
        self.checkAndHandleUserAudience { (canReachPeople) in
            self.delegate?.updateViewAfterFBRequest()
            if canReachPeople{
                //post
                print("ready to post")
                UIUtils.instance.showAlertwith(type: "fbPermission", accept: { (accept) in
                    if accept{
                        self.managePermissionAndShare(sale: sale)
                    }
                })
            }
        }
    }
}
