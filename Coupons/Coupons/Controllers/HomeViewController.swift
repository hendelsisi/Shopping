
//  Created by hend elsisi on 4/8/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit
import CoreData
import Foundation

import MaryPopin
import ENSwiftSideMenu

class HomeViewController: UIViewController,ENSideMenuDelegate,CartGroundDelegate ,CustomBarItemDelegate{
   
    func cartButtonDidClicked() {
        print("clicked")
       self.performSegue(withIdentifier: "WalletScreen", sender: nil)
        cart.reset()
    }
    
    var cart:CartGround = CartGround.instance
    var menuItem:CustomBarItem = CustomBarItem.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
    
    func menuButtonDidClicked() {
        toggleSideMenuView()
    }
    
    var open:Bool = true
    func sideMenuWillOpen() {
         darkenView.isHidden = false
        ItemAnimation.instance.animate(view: self.menuItem)
    }
    
    func sideMenuWillClose() {
         darkenView.isHidden = true
        ItemAnimation.instance.undoButtonRotation(view: self.menuItem)
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return open
    }
    
    func sideMenuDidOpen() {
        //
    }
    
    func sideMenuDidClose() {
        //
    }
    
    static let instance = HomeViewController()
    @IBOutlet weak var couponsTable: UITableView!
    var cartButton: UIButton?
    var coloredArray = [String]()
   // var lib = M13BadgeView()
    @IBOutlet weak var darkenView: UIView!


// MARK: -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      //  Utility.getInstance()?.delegate = self
       prepareView()
         dbFetch()
//        addObserverNot()
        getColorCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.open = true
        // cart.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       self.open = false
      self.closeMenu()
    }
    
    func closeMenu(){
        if isSideMenuOpen(){
            toggleSideMenuView()
        }
    }

    func getColorCell() {
        coloredArray = ["#8A2BE2", "#66CC00", "#0080FF", "#CC0000", "#FAF313"]
    }

// MARK:-notification Badge update
    func addObserverNot() {
//        NotificationCenter.default.addObserver(self, selector: Selector("receiveNotification:"), name: NOTIFICATION_CONDITION, object: nil)
    }

    @objc func receive(_ notification: Notification?) {
//        if (notification?.name == NOTIFICATION_CONDITION) {
//            if let aNumber = NotificationManager.getInstance()?.notifNumber() {
//                cartButton?.addSubview(aNumber)
//            }
//        }
    }

    func dbFetch() {
        couponsTable.dataSource = self
    DataBaseManager.instance.loadOffers(fetchedResultsController:self.fetchedResultsController)
    }

    func prepareView() {
//        APPSideMenuController.getInstance()?.shouldHideStatusBar = false
//        APPSideMenuController.getInstance()?.shouldHandleLeftPan = true
//        setNeedsStatusBarAppearanceUpdate()
//        navigationController?.navigationBar.isHidden = true
//        navigationItem.hidesBackButton = true
        darkenView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addBarIcons()
        self.sideMenuController()?.sideMenu?.delegate = self
        viewGiftPopUp()
    }

    func viewGiftPopUp() {
        print("viewGiftPopUp")
        if Utility.instance.isFirstshowGiftPopUp() {
            print("first time app")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let control: UIViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetGifts")
                control?.setPopinTransitionStyle(BKTPopinTransitionStyle(rawValue: 5)!)
                control?.setPopinAlignment(BKTPopinAlignementOption(rawValue: 0)!)
                control?.setPopinTransitionDirection(.top)
                control?.view.bounds = CGRect(x: 0, y: 0, width: 300, height: 450)
                self.presentPopinController(control, animated: true, completion: {() -> Void in
                      UserDefaultsManager.instance.saveObject("true" as AnyObject, key: "viewGifts")
                })
            }
       }
    }
    

// MARK: - cart badge icon
    func addBarIcons() {
        menuItem.delegate = self
        cart.delegate = self
        if Utility.instance.isEnglishSystem(){
            self.navigationItem.rightBarButtonItem?.customView = cart
            self.navigationItem.leftBarButtonItem?.customView = menuItem
        }
        else{
             self.navigationItem.rightBarButtonItem?.customView = cart
             self.navigationItem.leftBarButtonItem?.customView = menuItem
        }
}

    func configureCell(_ cell: CouponTableViewCell?, at indexPath: IndexPath?) {

        let coupItem = fetchedResultsController.object(at: indexPath!)
        cell?.storeImageView.image = UIImage(named: (coupItem.coup_brand_img)!)
        if coupItem.purchased != nil{
          print("post is :\(coupItem.purchased?.facebook_post)")
        }
    
       cell?.cellHeader.backgroundColor = UIColor.color(fromHexString:coloredArray[(indexPath?.row)!])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Claim") {
            let indexPath: IndexPath? = couponsTable.indexPathForSelectedRow
             let coupItem = fetchedResultsController.object(at: indexPath!)

            let transfer = segue.destination as? CouponDetailViewController
            transfer?.selectedCoup = coupItem
        }
    }

    // MARK: - fetchedResultsController
  fileprivate  lazy var fetchedResultsController: NSFetchedResultsController<Offer> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Offer> = Offer.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.CoreData.sortCoupTableKey, ascending: false)]

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managerContext = appDelegate.persistentContainer.viewContext

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managerContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let offers = fetchedResultsController.fetchedObjects else {
            
            return 0
        }
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let simpleTableIdentifier = Constants.TableViewCell.offerCell
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) as? CouponTableViewCell
        if cell == nil {
            cell = CouponTableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
        }
       configureCell(cell, at: indexPath)

        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "Claim", sender: nil)
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        couponsTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        couponsTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                couponsTable.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                couponsTable.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = couponsTable.cellForRow(at: indexPath) {
                configureCell(cell as? CouponTableViewCell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                couponsTable.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                couponsTable.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
}
