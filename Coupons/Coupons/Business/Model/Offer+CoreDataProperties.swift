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


extension Offer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Offer> {
        return NSFetchRequest<Offer>(entityName: "Offer")
    }

    @NSManaged public var coup_expDate: String?
    @NSManaged public var coup_desc: String?
    @NSManaged public var coup_id: String?
    @NSManaged public var coup_img_name: String?
    @NSManaged public var coup_brand_img: String?
    @NSManaged public var coup_link_Url: String?
    @NSManaged public var coup_store: String?
    @NSManaged public var purchased: MyWallet?

    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "coup_expDate" {
            self.coup_expDate = value as? String
        }
        else if key == "coup_desc"{
            self.coup_desc = value as? String
        }
        else if key == "coup_id"{
            self.coup_id = value as? String
        }
        else if key == "coup_img_name"{
            self.coup_img_name = value as? String
        }
        else if key == "coup_brand_img"
        {
            self.coup_brand_img = value as? String
        }
        else if key == "coup_link_Url"
        {
            self.coup_link_Url = value as? String
        }
        else if key == "coup_store"
        {
            self.coup_store = value as? String
        }
        else if key == "purchased"
        {
            self.purchased = value as? MyWallet
        }
    }


}

