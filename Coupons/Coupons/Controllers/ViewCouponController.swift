
//  ViewCouponController.swift
//  Arabian Center
//
//  Created by hend elsisi on 3/21/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class ViewCouponController: UIViewController {
  //  var selectedCoup: CouponsEntity?

    @IBOutlet weak var closeButton: UIButton!

    @IBAction func close(_ sender: Any) {
//        Utility.getInstance()?.isViewCouponCurrentlyDisplayed = false
//        APPSideMenuController.getInstance()?.shouldHideStatusBar = false
        popBack()
    }

    func popBack() {
        var pop = false
        for controller: UIViewController? in navigationController?.viewControllers ?? [UIViewController?]() {
            if (controller is WalletViewController) {
                if let aController = controller {
                    navigationController?.popToViewController(aController, animated: true)
                }
                pop = true
                break
            }
        }
        if !pop {
          //  performSegue(withIdentifier: MY_CART_SEGUE_IDENTIFIER, sender: nil)
        }
    }

// MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNeedsStatusBarAppearanceUpdate()
      //  Utility.getInstance()?.isViewCouponCurrentlyDisplayed = true
        hideTopBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      //  Utility.getInstance()?.isViewCouponCurrentlyDisplayed = true
        addGesture()
     //   APPSideMenuController.getInstance()?.isShouldHandleLeftPan = false
    }

// MARK::Gestures Delegate
    func addGesture() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchesBegan))
//        view.addGestureRecognizer(tap)
    }

    @objc func touchesBegan() {
        closeButton.isHidden = !closeButton.isHidden
    }

// MARK: : hide status bar to allow user take a full image screenshot
    func hideTopBar() {
        navigationController?.navigationBar.isHidden = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
