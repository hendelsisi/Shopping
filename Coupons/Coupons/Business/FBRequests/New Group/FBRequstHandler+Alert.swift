//
//  FBRequstHandler+Alert.swift
//  Coupons
//
//  Created by hend elsisi on 5/31/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation

extension FBRequstHandler{
    
     func showAlertForRepeatedRequestCase(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("rpeatRequestMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("rpeatRequestTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
     func fewFBFriendsAlert()  {
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("fewFriends", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: "")
    }
    
     func showCancelLoginAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("cancelLoginMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("cancelLoginTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
     func showFailedLoginAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("failedLoginMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("failedLoginTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
     func showCancelPublishAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("cancelPublishMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("cancelPublisTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
     func showFailedPublishAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("failedPublisMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("failedPublisTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
     func showCanceledFbShareAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("shareCanceledMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("shareCanceledTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
    
     func showFailureFbShareAlert(){
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("shareFailedMsg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: NSLocalizedString("shareFailedTitle", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""))
    }
}
