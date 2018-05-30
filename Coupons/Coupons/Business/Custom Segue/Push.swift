//
//  Push.swift
//  Coupons
//
//  Created by hend elsisi on 5/22/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class Push: UIStoryboardSegue {
    override func perform() {
        let transition = CATransition()
        transition.duration = 0.5
             transition.type = kCATransitionPush
        if Utility.instance.isEnglishSystem(){
            transition.subtype = kCATransitionFromRight
        }else{
             transition.subtype = kCATransitionFromLeft
        }
        source.view.window!.layer.add(transition, forKey: kCATransition)
        source.present(destination, animated: false, completion: nil)
        
        self.replaceRoot()
    }
    
    private func replaceRoot(){
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyNavigationController") as? UINavigationController
        UIApplication.shared.delegate?.window??.rootViewController = nav
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
}
