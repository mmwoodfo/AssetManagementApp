//
//  CheckoutEntity+CoreDataProperties.swift
//  InventoryApp
//
//  Created by Meghan on 11/6/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//
//

import Foundation
import CoreData


extension CheckoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckoutEntity> {
        return NSFetchRequest<CheckoutEntity>(entityName: "CheckoutEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var asuriteId: String?
    @NSManaged public var email: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var reason: String?
    @NSManaged public var loanedDate: String?
    @NSManaged public var expectedReturnDate: String?
    @NSManaged public var adaptorName: String?
    @NSManaged public var ticketNumber: String?
    @NSManaged public var signiture: Data?

}
