//
//  ConsumableEntity+CoreDataProperties.swift
//  InventoryApp
//
//  Created by Meghan on 11/6/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//
//

import Foundation
import CoreData


extension ConsumableEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConsumableEntity> {
        return NSFetchRequest<ConsumableEntity>(entityName: "ConsumableEntity")
    }

    @NSManaged public var type: String?
    @NSManaged public var count: Int32
    @NSManaged public var sku: String?

}
