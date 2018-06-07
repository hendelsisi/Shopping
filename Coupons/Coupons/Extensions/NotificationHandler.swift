//
//  NotificationHandler.swift
//  Coupons
//
//  Created by hend elsisi on 5/30/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import UserNotifications

extension NotificationManager{
    // MARK: user did revieve notification and click to view
     func userTap(toViewNotification response: UNNotificationResponse?) -> Bool {
        return response?.actionIdentifier == UNNotificationDefaultActionIdentifier
    }
    
     func getContent(_ title: String?) -> UNMutableNotificationContent? {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("notif title", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: "")
        content.body = title! + (NSLocalizedString("notif msg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
        
        return content
    }
    
     func registerNotif(_ request: UNNotificationRequest?) {
        if let aRequest = request {
            center?.add(aRequest, withCompletionHandler: {(_ error: Error?) -> Void in
                if error != nil {
                    print("not added \(error?.localizedDescription ?? "")")
                }
            })
        }
    }
    
     func handleNotificationRecieved(id:String){
        CartGround.instance.incrementDigit()
      let notificationCoupon =  CouponInterfaceOperationHandler.init(pid: id)
        notificationCoupon.handleCoupStateAfterNotification()
        //CouponInterfaceOperationHandler.sharedInstance.handleCoupStateAfterNotification(coupShereId: id)
    }
    
     func handleNotificationAlert(){
        UIUtils.instance.showAlertwith(type: "notify", accept: { (accept) in
            if accept{
                self.delegate?.willNavigateToWallet()
            }
        })
    }
}
