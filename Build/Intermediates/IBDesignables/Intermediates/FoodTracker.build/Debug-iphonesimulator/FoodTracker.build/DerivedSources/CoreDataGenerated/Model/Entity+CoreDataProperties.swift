//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by 一戸悠河 on 2017/02/14.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity");
    }

    @NSManaged public var coffeeName: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var img: NSData?
    @NSManaged public var studyTime: Int16

}
