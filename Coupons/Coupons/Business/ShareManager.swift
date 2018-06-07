
//  ShareManager.swift
//  Arabian Center
//
//  Created by hend elsisi on 4/10/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import SVProgressHUD

protocol ShareManagerDelegate: NSObjectProtocol {
//    func fbShareDidSucceed(sale:Offer?)
//      func fbShareDidFailed()
//      func updateControllerViewBeforRequest()
//      func updateControllerViewAfterRequest()
    func fbShareDidSucceed()
}

class ShareManager: NSObject,CouponFBOperationInterfaceDelegate{
    func fbSharingDidSucceed() {
//db and notification
        self.delegate?.fbShareDidSucceed()
    }
    
    func fbSharingDidFailed() {
               UIUtils.instance.showAlertWithMsg(NSLocalizedString("errorShareMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("errorShareTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
    }
    
//    func prepareUIforFBRequest() {
//        self.delegate?.updateControllerViewBeforRequest()
//    }
//
//    func updateViewAfterFBRequest() {
//        self.delegate?.updateControllerViewAfterRequest()
//    }
    
//    func sharingFacebookdidSucceeded(pid: String,offer:Offer?) {
//        //check back first
//        print("success")
//        self.checkAfterShare(pid: pid,sale:offer )
//    }
//
//    func sharingFacebookdidFailed() {
//        UIUtils.instance.showAlertWithMsg(NSLocalizedString("errorShareMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("errorShareTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
//    }
    
   // var selectedCoup:Offer?
   // var sharecont:CouponDetailViewController?
    static let instace = ShareManager()
    weak var delegate: ShareManagerDelegate?
     var loginManager:LoginManager = LoginManager()
    
    //the coupon is not added to the cart until make sure the post is public
     func checkAfterShare(pid: String,sale:Offer?){
//        if Utility.instance.handleNetwork() {
//            FBRequstHandler.sharedInstance.delegate = self
//            FBRequstHandler.sharedInstance.checkPostPrivacy(id: pid,block: {finish,privacy in
//             if finish{
//                    // add to cart and change the button title
//                    print(privacy)
//                    if privacy == "private" || privacy == "deleted"{
//
//                          UIUtils.instance.showAlertWithMsg( NSLocalizedString("privatePostMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title:NSLocalizedString("privatePostTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
//
//                    }else{
//                        //add local notification
//                          NotificationManager.instance.addNotif( withTitle: sale?.coup_store, checkId: pid)
//                    self.addCoupAndAlert(coup: sale, pid: pid)
//                    }
//                }
//                else{
//                    UIUtils.instance.showAlertWithMsg(NSLocalizedString("errorShareMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("errorShareTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
//                }
//            })
//        }
    }
    
        func addLocalNotification(_ sharedCoupon: Offer?,postId:String) {
            NotificationManager.instance.addNotif(withTitle: sharedCoupon?.coup_store, checkId: postId)
        }
    
    func addCoupAndAlert(coup:Offer?,pid:String )  {
//        DataBaseManager.instance.addValidShareState(coup: coup,postId:pid ) { (finish) in
//            if finish{
//               self.delegate?.fbShareDidSucceed(sale: coup)
//                self.addLocalNotification(coup, postId: pid)
//
//                 UIUtils.instance.showAlertWithMsg(NSLocalizedString("aftershareMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("aftershareTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
//            }
//            else{
//        UIUtils.instance.showAlertWithMsg(NSLocalizedString("errorShareMsg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("errorShareTitle", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
//            }
//        }
    }
    
   func shareActionSheet(_ urlLink: String?) -> UIActivityViewController? {
        let textToShare = ""
        let myWebsite = URL(string: urlLink ?? "")
        let objectsToShare = [textToShare, myWebsite!] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        return activityVC
    }

   func fbShare(_ coup: Offer?) {
       // self.selectedCoup = coup
       // self.sharecont = share
    
        if  Utility.instance.handleNetwork(){
            shareMethod(coup)
        }
    }

    
// MARK: - handle fbsharing
       private func shareMethod(_ coup: Offer?) {
//        FBRequstHandler.sharedInstance.delegate = self
//        FBRequstHandler.sharedInstance.shareToFB(coup: coup)
        CouponFBOperationInterface.instance.delegate = self
        CouponFBOperationInterface.instance.shareOfferOnFacebookUserWall(coup: coup)
}
    
}
