
//  DataBaseManager.swift
//  Arabian Center
//
//  Created by hend elsisi on 3/23/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import CoreData
import UIKit


 class DataBaseManager: NSObject {

    static let instance = DataBaseManager()
    var deletedOrder:MyWallet?
    
    
    lazy var managedContext:NSManagedObjectContext = {
         let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var managedContext = appDelegate?.persistentContainer.viewContext
        return managedContext!
    }()
  
    func loadOffers(fetchedResultsController:NSFetchedResultsController<Offer>){
        //persistant container
        let persistentContainer = NSPersistentContainer(name: Constants.CoreData.modelName)
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
    }
    
    func isPrivatePostPurchasedCoupon(id:String) -> Bool {
        let fetchRequest: NSFetchRequest<MyWallet> = MyWallet.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "facebook_post = %@", id)
        let item = try! managedContext.fetch(fetchRequest)
        let sharedItem = item.first
        return sharedItem?.post_status == "private"
    }
    
    func loadData(fetchedResultsController:NSFetchedResultsController<MyWallet>,foundResult: @escaping (Bool) -> Void){
        //persistant container
        let persistentContainer = NSPersistentContainer(name: Constants.CoreData.modelName)
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                 foundResult(false)
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    foundResult(false)
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                foundResult(true)
            }
        }
    }
    
    func retriveAndInitCoreData() {
        do {
            let carFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreData.offerEntityName)
            let count:Int = try managedContext.count(for: carFetch)
             
            if(count == 0){
                storeDummyData()
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
   private func storRequest() -> Bool {
        do {
            print("saved")
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func editCouponToRecivedCodeState(id:String,dbedit:(Bool)->Void)  {
        let fetchRequest: NSFetchRequest<MyWallet> = MyWallet.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "facebook_post = %@", id)
        let item = try! managedContext.fetch(fetchRequest)
        let sharedItem = item.first
        sharedItem?.post_status = "valid"
        do {
            try managedContext.save()
            dbedit(true)
        }
        catch {
            dbedit(false)
            print("Saving Core Data Failed: \(error)")
        }
    }
    
    func editCouponToPrivateShare(id:String)  {
        let fetchRequest: NSFetchRequest<MyWallet> = MyWallet.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "facebook_post = %@", id)
        let item = try! managedContext.fetch(fetchRequest)
        let sharedItem = item.first
        sharedItem?.post_status = "private"
        do {
            try managedContext.save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    //delete the coupons from user which is not published on the social network
    func deleteCouponfromCart(id:String,dbDelete:(Bool)->Void)  {
        //
        let fetchRequest: NSFetchRequest<MyWallet> = MyWallet.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "facebook_post = %@", id)
        
        let item = try! managedContext.fetch(fetchRequest)
        for object in item {
            managedContext.delete(object)
        }
        do {
            try managedContext.save()
           dbDelete(true)
        }
        catch {
            print("Saving Core Data Failed: \(error)")
             dbDelete(false)
            
        }
    }
    
    func addValidShareState(coup:Offer?,postId:String,dbstore:(Bool)->Void)  {
                         print("the post id is \(postId)")
                        let offerEntity = NSEntityDescription.entity(forEntityName:Constants.CoreData.walletEntityName, in: managedContext)!
                        let cart = NSManagedObject(entity: offerEntity, insertInto: managedContext)
                let myCrat:[String:AnyHashable] = ["coup_id":coup!.coup_id!,"coupon":coup!,"facebook_post":postId,"post_status":"inProcess","postDate":Date()]
                cart.setValue(myCrat, forKey: "cart")
        
        if self.storRequest(){
            
            dbstore(true)
           
        }else{
             dbstore(false)
        }
    }


    func  modifyCoupStateAfterNotification(id:String,dbedit:(Bool)->Void){
    let fetchRequest: NSFetchRequest<MyWallet> = MyWallet.fetchRequest()
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(format: "facebook_post = %@", id)
    let item = try! managedContext.fetch(fetchRequest)
    let sharedItem = item.first
       
    sharedItem?.post_status = "check"
    do {
        try managedContext.save()
        print("success")
        dbedit(true)
    }
    catch {
        dbedit(false)
        print("Saving Core Data Failed: \(error)")
    }
    }
    
    func storeDummyData() {
        
        let offerEntity = NSEntityDescription.entity(forEntityName:  Constants.CoreData.offerEntityName, in: managedContext)!
        let first = NSManagedObject(entity: offerEntity, insertInto: managedContext)
                first.setValue("http://www2.hm.com/en_gb/productpage.0566370001.html", forKey: "coup_link_Url")
     
                first.setValue("31 Mar 2018", forKey: "coup_expDate")
        
                first.setValue("e234244", forKey: "coup_id")
       
                first.setValue("Coupons_screen_H&M", forKey: "coup_brand_img")
        first.setValue("shareOffer_H&M", forKey: "coup_img_name")
        
                first.setValue("50% off at H&M,or online via promo code FRINDS (03/31)", forKey: "coup_desc")
        
                first.setValue("H&M", forKey: "coup_store")
        
        let sec = NSManagedObject(entity: offerEntity, insertInto: managedContext)
                        sec.setValue("https://www.thebodyshop.com/en-us/", forKey: "coup_link_Url")
        
                sec.setValue("31 Mar 2018", forKey: "coup_expDate")
        
                sec.setValue("d243424", forKey: "coup_id")
        
                sec.setValue("Coupons_screen_bodyShop", forKey: "coup_brand_img")
         sec.setValue("shareOffer_bodyshop", forKey: "coup_img_name")
        
                sec.setValue("$5 off $25 at The Body Shop or online via promo code SDOSAVE525 (03/31)", forKey: "coup_desc")
        
                sec.setValue("The Body Shop", forKey: "coup_store")
       

        let third = NSManagedObject(entity: offerEntity, insertInto: managedContext)
                third.setValue("https://www.costa.co.uk/terms/", forKey: "coup_link_Url")
        
                third.setValue("31 Mar 2018", forKey: "coup_expDate")
        
                third.setValue("c343233", forKey: "coup_id")
        
                third.setValue("Coupons_screen_costa", forKey: "coup_brand_img")
         third.setValue("shareOffer_costa", forKey: "coup_img_name")
        
                third.setValue( "50% off a single meal at Costa (03/31)", forKey: "coup_desc")
        
                third.setValue("Costa", forKey: "coup_store")
       

         let fourth = NSManagedObject(entity: offerEntity, insertInto: managedContext)
                fourth.setValue("https://online.kfc.co.in/deals/listing", forKey: "coup_link_Url")
        
                fourth.setValue("31 Mar 2018", forKey: "coup_expDate")
        
                fourth.setValue("b245336", forKey: "coup_id")
        
                fourth.setValue("Coupons_screen_kfc", forKey: "coup_brand_img")
         fourth.setValue("shareOffer_kfc", forKey: "coup_img_name")
        
                fourth.setValue("Second lunch free today at KFC (03/31)", forKey: "coup_desc")
        
                fourth.setValue( "KFC", forKey: "coup_store")
      

         let fifth = NSManagedObject(entity: offerEntity, insertInto: managedContext)
                fifth.setValue("https://www.splashfashions.com/sa/en/?gclid=EAIaIQobChMIuebwlois2gIVa7HtCh2mtgWNEAAYASAAEgK3qPD_BwE", forKey: "coup_link_Url")
        
                fifth.setValue("31 Mar 2018", forKey: "coup_expDate")
        
                fifth.setValue("a094343", forKey: "coup_id")
        
                fifth.setValue("Coupons_screen_splash", forKey: "coup_brand_img")
         fifth.setValue("shareOffer_splash", forKey: "coup_img_name")
        
                fifth.setValue("Enjoy Clothes and gifts for your friends and family with lower price during this month", forKey: "coup_desc")

                fifth.setValue("Splash", forKey: "coup_store")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
