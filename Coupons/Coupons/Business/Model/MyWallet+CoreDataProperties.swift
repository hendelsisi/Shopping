//
//  User+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Krzysztof Kempiński on 17.04.2018.
//  Copyright © 2018 test. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension MyWallet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyWallet> {
        return NSFetchRequest<MyWallet>(entityName: "MyWallet")
    }

 //   @NSManaged public var coup_id: String?
     @NSManaged public var coupon: Offer?
     @NSManaged public var facebook_post: String?
    @NSManaged public var post_status: String?
     @NSManaged public var postDate: Date?
    
    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "cart" {
            
           let dic = value as? [String:AnyHashable]
            
            self.coupon = dic?["coupon"] as? Offer
        
            self.post_status = dic?["post_status"] as? String
       
            self.facebook_post = dic?["facebook_post"] as? String
       
          //  self.coup_id = dic?["coup_id"] as? String
        
            self.postDate = dic?["postDate"] as? Date
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<Offer> = Offer.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "coup_id = %@", (dic?["coup_id"] as? String)!)
            let item = try! managedContext.fetch(fetchRequest)
            let cItem = item.first
            cItem?.purchased = self
    }
}
    
    
}
