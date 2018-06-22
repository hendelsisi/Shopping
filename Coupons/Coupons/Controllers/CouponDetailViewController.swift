
//  Created by hend elsisi on 4/5/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit
import Social
import SVProgressHUD

enum CellCouponInfoTable : Int {
    case cell_COUP_INFO = 0,
     cell_COUP_EXP_DATE,
     cell_COUP_SUMMARY,
     cell_ACTIONS,
     cell_COUP_RULS
}

class CouponDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,signUpRequest,RoundedButtonDelegate{
    
    func couponStatusChanged(for id: String) {
        if self.selectedCoup?.coup_id == id{
            self.redeemButton.updateView(coup: self.selectedCoup)
        }
    }
    
    func updateToViewFrozen() {
         self.view.isUserInteractionEnabled = false
    SVProgressHUD.setContainerView(UIApplication.shared.delegate?.window??.rootViewController?.view)
        SVProgressHUD.show()
    }
    
    func updateToInteractiveView() {
        self.view.isUserInteractionEnabled = true
        SVProgressHUD.dismiss()
    }
    
    var selectedCoup: Offer?
    var isShareSceed = false
   // var succeed = ""
    var isSubscibe = false

    
    @IBOutlet weak var redeemButton: RoundedButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareView()
        initData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
// MARK: - redeem Offer action
    @IBAction func redeemOffer(_ sender: Any) {
        self.redeemButton.delegate = self
        self.redeemButton.requestOffer(cont: self, coup: self.selectedCoup)       
    }
 

    func initData() {
        isSubscibe = false
    }

    func prepareView() {
       
        self.redeemButton.updateView(coup: self.selectedCoup) 
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = false
        self.sideMenuController()?.sideMenu?.allowPanGesture = false
      //  APPSideMenuController.getInstance()?.shouldHandleLeftPan = false
    }
    

// MARK - Location Delegate
    func locationMngrDidSucceed() {
       // goToShare()
    }

    func locationMngrDidFail() {
       // Utility.getInstance()?.alertMsg(self, andMsg: NSLocalizedString("location msg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), andTitle: "")
    }

// MARK - handle view navigation
    func goToSignUp() {
        performSegue(withIdentifier: "register", sender: nil)
    }

    @objc func goback(_ not: NotificationCenter?) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "register") {
            let transfer = segue.destination as? SignUpViewController
            transfer?.selectedCoup = selectedCoup
            transfer?.delegate = self
        }
    }

    func signUpdidSucceed() {
        showAlertonLogin()
    }

    func showAlertonLogin() {
        UIUtils.instance.showAlertWithMsg(NSLocalizedString("login msg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), title: NSLocalizedString("Welcome Back !", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""))
    }

// MARK - tableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == CellCouponInfoTable.cell_COUP_INFO.rawValue {
            let simpleTableIdentifier = "Cell"
       
            var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) as? CouponDataCell
            if cell == nil {
                cell = CouponDataCell(style: .default, reuseIdentifier: simpleTableIdentifier)
            }
            cell?.coup_Brand_img.image = UIImage(named: (selectedCoup?.coup_brand_img)!)
            cell?.brandName.text = selectedCoup?.coup_store
            if let aCell = cell {
            return aCell
            }
            return UITableViewCell()
        }
        else if indexPath.row == CellCouponInfoTable.cell_COUP_EXP_DATE.rawValue {
            let simpIdentifier = "secCell"
            var cell2: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: simpIdentifier)
            if cell2 == nil {
                cell2 = UITableViewCell(style: .default, reuseIdentifier: simpIdentifier)
            }
            if let aCell2 = cell2 {
                return aCell2
            }
        }
            else if indexPath.row == CellCouponInfoTable.cell_COUP_SUMMARY.rawValue {
            let simpIdentifier = "thirdCell"
            var cell2: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: simpIdentifier)
            if cell2 == nil {
                cell2 = UITableViewCell(style: .default, reuseIdentifier: simpIdentifier)
            }
            if let aCell2 = cell2 {
                return aCell2
            }

        }
            else if indexPath.row == CellCouponInfoTable.cell_ACTIONS.rawValue {
            let simpIdentifier = "fourthCell"
            var cell2: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: simpIdentifier)
            if cell2 == nil {
                cell2 = UITableViewCell(style: .default, reuseIdentifier: simpIdentifier)
            }
            if let aCell2 = cell2 {
                return aCell2
            }
            return UITableViewCell()
        }
            else {
            let simpIdentifier = "fifthCell"
            var cell2: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: simpIdentifier)
            if cell2 == nil {
                cell2 = UITableViewCell(style: .default, reuseIdentifier: simpIdentifier)
            }
            if let aCell2 = cell2 {
                return aCell2
            }
           
       }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == CellCouponInfoTable.cell_COUP_INFO.rawValue{
            return 200
        }
        else if indexPath.row == CellCouponInfoTable.cell_COUP_EXP_DATE.rawValue {
            return 20
        } else if indexPath.row == CellCouponInfoTable.cell_COUP_SUMMARY.rawValue {
            return 80
        } else if indexPath.row == CellCouponInfoTable.cell_ACTIONS.rawValue {
            return 70
        }
        else {
            return 200
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

// MARK - collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as? IconCollectionViewCell
        cell?.imgIcon.image = UIImage(named: "detail_screen_\(indexPath.item + 2)")
        cell?.tag = indexPath.row
        if let aCell = cell {
            return aCell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == CellCouponInfoTable.cell_ACTIONS.rawValue {
            if let anUrl = ShareManager.instace.shareActionSheet(selectedCoup?.coup_link_Url) {
                present(anUrl, animated: true) {() -> Void in
                    
                }
            }
        }
    }
}
