//
//  Item+CoreDataProperties.swift
//  Reseller
//
//  Created by Lady Barretto on 08/12/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation
import CoreData

extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var brand: String?
    @NSManaged public var product: String?
    @NSManaged public var price: Float
    @NSManaged public var quantity: Int16
    @NSManaged public var toUser: NSSet?

}

// MARK: Generated accessors for toUser
extension Item {

    @objc(addToUserObject:)
    @NSManaged public func addToToUser(_ value: UserData)

    @objc(removeToUserObject:)
    @NSManaged public func removeFromToUser(_ value: UserData)

    @objc(addToUser:)
    @NSManaged public func addToToUser(_ values: NSSet)

    @objc(removeToUser:)
    @NSManaged public func removeFromToUser(_ values: NSSet)

}
