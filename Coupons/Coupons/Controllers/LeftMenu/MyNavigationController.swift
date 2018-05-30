//
//  MyNavigationController.swift
//  Coupons
//
//  Created by hend elsisi on 5/16/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation
import UIKit
import ENSwiftSideMenu

class MyNavigationController: ENSideMenuNavigationController,MenuTableViewControlDelegate,NotificationManagerDelegate {
   
    func willNavigateToWallet() {
        CartGround.instance.reset()
        if isSideMenuOpen(){
            self.closeMenuWithAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.goToWallet()
            }
        }
        else{
           self.goToWallet()
        }
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSideMenu()
        NotificationManager.instance.delegate = self
        print("under")
        
       
       
    }
    
     // MARK: - handle wallet screen view and navigation
    func goToWallet(){
        let vCoupn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyGiftsViewController") as? WalletViewController
        self.addBackAction(cont:vCoupn!)
        
        if !(self.topViewController?.isKind(of: WalletViewController.self))!{
            let nav =  UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController?
            
            nav??.pushViewController(vCoupn!, animated: true)
        }
    }
    
    func addBackAction(cont:WalletViewController){
        
        let item = UIBarButtonItem(title: NSLocalizedString("Back", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), style: .plain, target: self, action: #selector(self.back))
        
        cont.navigationItem.hidesBackButton = true
        
        if Utility.instance.isEnglishSystem(){
            cont.navigationItem.leftBarButtonItem = item
        }else{
            cont.navigationItem.rightBarButtonItem = item
        }
    }
    
    @objc func back(cont:WalletViewController){
        print("goes here")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backAction"), object: self)
    }
    
    func closeMenuWithAnimation(){
        if isSideMenuOpen(){
            sideMenu?.bouncingEnabled = false
            sideMenu?.animationDuration = 0.15
            toggleSideMenuView()
        }
        sideMenu?.bouncingEnabled = true
        sideMenu?.animationDuration = 0.4
    }
    
    func goSingInScreen() {
        
   self.closeMenuWithAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
        (UIApplication.shared.delegate?.window??.rootViewController)!.performSegue(withIdentifier: "LogIn", sender: self)
            
        }
    }

func addSideMenu(){
    MenuTableViewControl.instance.delegate = self
    if Utility.instance.isEnglishSystem() {
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: MenuTableViewControl.instance, menuPosition:.left)
    }
    else{
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: MenuTableViewControl.instance, menuPosition:.right)
    }
     sideMenu?.menuWidth = 200.0
    
     view.bringSubview(toFront: navigationBar)
}
}

extension MyNavigationController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
}
