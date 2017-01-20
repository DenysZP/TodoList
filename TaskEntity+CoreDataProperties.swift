//
//  TaskEntity+CoreDataProperties.swift
//  TodoList
//
//  Created by imac on 25.12.16.
//  Copyright © 2016 imac. All rights reserved.
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity");
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var isArchived: Bool
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskTitle: String?

}
