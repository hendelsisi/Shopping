//
//  MenuTableViewControl.swift
//  Coupons
//
//  Created by hend elsisi on 5/21/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

protocol MenuTableViewControlDelegate {
    func goSingInScreen()
}

class MenuTableViewControl: UITableViewController {
static let instance = MenuTableViewControl()
    var iconArray = [String]()
    var titlesArray = [String?]()
    var changeUserStateMenuTitle:String?
    var delegate:MenuTableViewControlDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillData()
        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("appear menu")
    }
    
//    func getUserLoginStatusChangeTitle()->String{
//        print("here title")
//        if Utility.instance.isFirstTimeSignUp() {
//            return NSLocalizedString("LogIn", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: "")
//        }else{
//            return NSLocalizedString("Logout", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: "")
//        }
//    }
    
    func fillData(){
        iconArray = [String]()
        titlesArray = [NSLocalizedString("Find Deals", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), NSLocalizedString("Saved", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), NSLocalizedString("Wish List", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), NSLocalizedString("My Account", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""),NSLocalizedString("LogIn", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: "") , NSLocalizedString("About", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: "")]
        for i in 0..<7 {
            if i == 4 {
                if Utility.instance.isFirstTimeSignUp(){
                    let ex = "icon-menu-logIn"
                    iconArray.append(ex)
                }
                else{
                    let ex = "icon-menu-logOut"
                    iconArray.append(ex)
                }
            }
            else{
                let ex = "icon-menu-\(i + 1)"
                iconArray.append(ex)
            }
        }
    }
    
    func prepareView(){
        self.tableView?.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        self.tableView?.separatorStyle = .none
        self.tableView?.backgroundColor = UIColor.clear
        self.tableView?.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let simpleTableIdentifier2 = "tupple"
            var Cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier2)
            if Cell == nil {
                Cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier2)
            }
        
        if indexPath.row == 4 {
            
            self.addCellStatusloginTitle(cell: Cell!)
        }
        else{
           Cell?.textLabel?.text = titlesArray[indexPath.row]
            Cell?.imageView?.image = UIImage.init(named: iconArray[indexPath.row])
        }
            return Cell!
    }
    
    func addCellStatusloginTitle(cell:UITableViewCell){
        if Utility.instance.isFirstTimeSignUp() {
            cell.textLabel?.text = NSLocalizedString("LogIn", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: "")
            cell.imageView?.image = UIImage.init(named: "icon-menu-logIn")
        }
        else{
            cell.textLabel?.text = NSLocalizedString("Logout", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: "")
            cell.imageView?.image = UIImage.init(named: "icon-menu-logOut")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let aRow = self.tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: aRow, animated: true)
        }
        if indexPath.row == 4{
          self.handleUserAccountLogin()
        }
    }
    
    func handleUserAccountLogin(){
        toggleSideMenuView()
        if !Utility.instance.isFirstTimeSignUp() {
            UIUtils.instance.showAlertwith(type: "logOut") { (accept) in
                if accept{
                    Utility.instance.logUserEmailOut()
                    self.tableView.reloadData()
                }
            }
        }
        else{
            self.delegate?.goSingInScreen()
        }
    }
}
