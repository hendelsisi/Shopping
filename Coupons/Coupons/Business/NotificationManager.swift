
//  NotificationManager.swift
//  Arabian Center
//
//  Created by hend elsisi on 3/24/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

protocol NotificationManagerDelegate: NSObjectProtocol {
    func willNavigateToWallet()
}

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
   
    static let instance = NotificationManager()
    var receicedForground:Bool = false
    var center: UNUserNotificationCenter?
    weak var delegate: NotificationManagerDelegate?

    func addNotif( withTitle title: String?,checkId:String) {
        center?.getNotificationSettings(completionHandler: {(_ settings: UNNotificationSettings) -> Void in
            if settings.authorizationStatus == .authorized {
                let content: UNMutableNotificationContent? = self.getContent(title)
               // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
                var request: UNNotificationRequest? = nil
                if let aContent = content {
                    request = UNNotificationRequest(identifier: checkId, content: aContent, trigger: trigger)
                }
                self.registerNotif(request)
            }
        })
    }

    func displayAlertNotification()  {
        UIUtils.instance.showAlertWithMsg("msg", title: "test")
    }
    
    func requestNotificationAuthorization() {
            let options: UNAuthorizationOptions = .alert
      center?.requestAuthorization(options: options, completionHandler: {(_ granted: Bool, _ error: Error?) -> Void in
                if !granted {
                    print("notification not granted")
                }
            })
    }

    override init() {
        super.init()
        center = UNUserNotificationCenter.current()
        center?.delegate = self
    }

// MARK: - add fire notification after user share coupon for code redeem

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
    
    func removeLocalNotification(id:String){
        center?.removeDeliveredNotifications(withIdentifiers: [id])
        center?.removePendingNotificationRequests(withIdentifiers: [id])
    }

// MARK: - userNotification Center Delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let presentationOptions: UNNotificationPresentationOptions = [.alert]
        
        self.receicedForground = true
        CartGround.instance.incrementDigit()
       CouponState.sharedInstance.handleCoupStateAfterNotification(coupShereId: notification.request.identifier)
        
        completionHandler(presentationOptions)
        print("id :- \(notification.request.identifier)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // increment badge icon
        if !self.receicedForground{
            CartGround.instance.incrementDigit()
             CouponState.sharedInstance.handleCoupStateAfterNotification(coupShereId: response.notification.request.identifier)
        }
        let userOpenRecivedNot: Bool = userTap(toViewNotification: response)
    
        if userOpenRecivedNot {
            UIUtils.instance.showAlertwith(type: "notify", accept: { (accept) in
                if accept{
                 
                    self.delegate?.willNavigateToWallet()
                }
            })
        }
    }

// MARK: user did revieve notification and click to view
   private func userTap(toViewNotification response: UNNotificationResponse?) -> Bool {
        return response?.actionIdentifier == UNNotificationDefaultActionIdentifier
    }
}

