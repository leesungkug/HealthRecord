//
//  CustomWorkoutEntity+CoreDataProperties.swift
//  healthChar
//
//  Created by sungkug_apple_developer_ac on 4/18/24.
//
//

import Foundation
import CoreData


extension CustomWorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomWorkoutEntity> {
        return NSFetchRequest<CustomWorkoutEntity>(entityName: "CustomWorkoutEntity")
    }

    @NSManaged public var comment: String?
    @NSManaged public var parts: String?

}

extension CustomWorkoutEntity : Identifiable {

}
