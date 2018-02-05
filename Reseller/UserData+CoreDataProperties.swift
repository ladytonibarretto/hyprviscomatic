//
//  UserData+CoreDataProperties.swift
//  Reseller
//
//  Created by Lady Barretto on 08/12/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import Foundation
import CoreData

extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData");
    }

    @NSManaged public var username: String?
    @NSManaged public var toItem: NSSet?

}

// MARK: Generated accessors for toItem
extension UserData {

    @objc(addToItemObject:)
    @NSManaged public func addToToItem(_ value: Item)

    @objc(removeToItemObject:)
    @NSManaged public func removeFromToItem(_ value: Item)

    @objc(addToItem:)
    @NSManaged public func addToToItem(_ values: NSSet)

    @objc(removeToItem:)
    @NSManaged public func removeFromToItem(_ values: NSSet)

}
