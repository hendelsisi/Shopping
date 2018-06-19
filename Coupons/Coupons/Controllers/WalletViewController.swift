
//  WalletViewController.swift
//  Arabian Center
//
//  Created by hend elsisi on 4/9/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit
import CoreData

class WalletViewController: UIViewController,UITableViewDelegate {
  
    var managedObjectContext: NSManagedObjectContext?
   
    @IBOutlet weak var myCardsTable: UITableView!
    @IBOutlet weak var tablePlaceHolder: UIView!
        
    var isEmptyScreen = false
    var codeUseGetCount:Int = 0
    
    // MARK: - fetchedResultsController
    fileprivate  lazy var fetchedResultsController: NSFetchedResultsController<MyWallet> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<MyWallet> = MyWallet.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.CoreData.sortWalletTableKey, ascending: false)]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managerContext = appDelegate.persistentContainer.viewContext
        
         do {
            let count:Int = try managerContext.count(for: fetchRequest)
            if count == 0
            { self.isEmptyScreen = true
                updateView()
            }
        }
         catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managerContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.back(notfication:)), name: NSNotification.Name(rawValue: "backAction"), object: nil)
    }
    
   @objc func back(notfication:NSNotification){
    print("pop")
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       myCardsTable.delegate = self
        myCardsTable.dataSource = self
        dbFetch()
    }

    func updateView() {
        if isEmptyScreen {
            tablePlaceHolder.isHidden = false
            myCardsTable.isHidden = true
        }
        else{
             myCardsTable.isHidden = false
        }
    }
    
    func dbFetch() {
        DataBaseManager.instance.loadData(fetchedResultsController: self.fetchedResultsController) { (gotResults) in
            if !gotResults {
                self.isEmptyScreen = true
                self.updateView()
            }
            else{
                self.myCardsTable.reloadData()
            }
        }
    }

// MARK: - buttonActions
    @IBAction func showCode(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: myCardsTable)
        let indexPath: IndexPath? = myCardsTable.indexPathForRow(at: buttonPosition)
        let coupItem = fetchedResultsController.object(at: indexPath!)
        let cell :CouponCardViewCell = self.myCardsTable.cellForRow(at: indexPath!) as! CouponCardViewCell
        cell.getCode.requestOffer(cont: self, coup: coupItem.coupon)
    }

    @IBAction func getCoup(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }

    @IBAction func backAction(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }

    // MARK: - tableView Datasource
    func configureCell(_ cell: CouponCardViewCell?, at indexPath: IndexPath?) {
        let coupItem = fetchedResultsController.object(at: indexPath!)
        print("image name :\(coupItem.coupon?.coup_img_name ?? "")")
        cell?.storePic.image = UIImage(named: (coupItem.coupon?.coup_brand_img)!)
        cell?.offerDescription.text = coupItem.coupon?.coup_desc
        cell?.getCode.updateView(coup: coupItem.coupon) 
        print("approve \(coupItem.post_status ?? "")")
        print("post id :\(coupItem.facebook_post ?? "")")
        if coupItem.coupon?.purchased != nil{
            print("not nil")
        }
       // print("id = \(coupItem.coupon?.coup_id ?? "")")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIUtils.instance.showAlertwith(type: "userDelete") { (accept) in
            if accept{
                let coupItem = self.fetchedResultsController.object(at: indexPath)
                CouponState.sharedInstance.handleUserDeleteCoupon(coupItem: coupItem)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "") {
            let transfer = segue.destination as? ViewCouponController
            transfer?.setNeedsStatusBarAppearanceUpdate()
            transfer?.modalPresentationCapturesStatusBarAppearance = true
        }
    }
}

extension WalletViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myCardsTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myCardsTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                myCardsTable.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                myCardsTable.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = myCardsTable.cellForRow(at: indexPath) {
                configureCell(cell as? CouponCardViewCell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                myCardsTable.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                myCardsTable.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
}

extension WalletViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let simpleTableIdentifier = Constants.TableViewCell.walletCell
       
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) as? CouponCardViewCell
        if cell == nil {
            cell = CouponCardViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
        }
        configureCell(cell, at: indexPath)
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let offers = fetchedResultsController.fetchedObjects else {
        
            return 0
        }
        return offers.count
    }
    
    
}
