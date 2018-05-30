//  Converted to Swift 4 by Swiftify v4.1.6680 - https://objectivec2swift.com/
//
//  Utility.swift
//  Arabian Center
//
//  Created by hend elsisi on 3/22/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

protocol LeftMenuListnerDelegate: NSObjectProtocol {
    func sideMenuisOpen()

  //  func sideMenu(_ state: MFSideMenuState)
}

public class Utility: NSObject {
    //single tone object
static let instance = Utility()
    

    var window: UIWindow{
        get{
            return ((UIApplication.shared.delegate?.window)!)!
        }
    }

    func handleNetworkCondition()  {
        if !self.isNetworkConnected() {
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("network msg", tableName: "LocalizeFile", bundle: Bundle.main, comment: ""), title: "")
        }
    }
    
    func isNetworkConnected()->(Bool){
    return Reachability.checkRechability()
    }
    
    func handleNetwork()->Bool{
        self.handleNetworkCondition()
        return self.isNetworkConnected()
    }
    
   func isFirstTimeSignUp() -> Bool {
        return  UserDefaultsManager.instance.getObjectForKey(Constants.UserDefaults.registeredKey) == nil
    }
    
    func logUserEmailOut(){
        UserDefaultsManager.instance.removeObject(Constants.UserDefaults.registeredKey)
    }

    func goToInitialScreen() {
        let isFirstTime: Bool = isVisitor()
         
        if !isFirstTime {
          goHome()
        }
        else {
            UserDefaultsManager.instance.saveObject(true as AnyObject, key: "tutorial")
        }
    }

    func isEnglishSystem() -> Bool {
        return getSystemLanguage() == "en"
    }
    
     func goHome(){
          let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyNavigationController") as? UINavigationController
        
                    UIApplication.shared.delegate?.window??.rootViewController = nav
                    UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }

//    func isFirstshowPopUp() -> Bool {
//        return Bool(!UserDefaults.standard.object(forKey: USER_DEFAULTS_POP_UP_KEY) ?? false)
//    }
//
    func isFirstshowGiftPopUp() -> Bool {
        return  UserDefaultsManager.instance.getObjectForKey("viewGifts") == nil
    }

    //application alert
    func alertMsg(_ ref: UIViewController?, andMsg msg: String?, andTitle title: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let oKButton = UIAlertAction(title: NSLocalizedString("Ok", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), style: .default, handler: {(_ action: UIAlertAction?) -> Void in
                //Handle no, thanks button
            })
        alert.addAction(oKButton)
        ref?.present(alert, animated: true) {() -> Void in }
    }

    func getSystemLanguage() -> String? {
        return Bundle.main.preferredLocalizations[0]
    }

    func isVisitor() -> Bool {
        return (UserDefaultsManager.instance.getObjectForKey("tutorial") == nil)
    }

//    func getFaceBookUrl() -> String? {
//        return FACEBOOK_URL
//    }

// MARK::left menu delegate
//    func leftMenuisAppeared() {
//        delegate?.sideMenuisOpen()
//    }
}
