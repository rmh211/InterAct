//
//  Interaction+CoreDataProperties.swift
//  InterAct
//
//  Created by Robert Huber on 10/3/22.
//
//

import Foundation
import CoreData


extension Interaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Interaction> {
        return NSFetchRequest<Interaction>(entityName: "Interaction")
    }

    @NSManaged public var date: Date
    @NSManaged public var interactionQuality: Int
    @NSManaged public var person: Person

}

extension Interaction : Identifiable {

}
extension Interaction: Comparable {
    public static func < (lhs: Interaction, rhs: Interaction) -> Bool {
        return lhs.date < rhs.date
    }
}
