//
//  Person+CoreDataProperties.swift
//  InterAct
//
//  Created by Robert Huber on 10/6/22.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var image: Data
    @NSManaged public var name: String
    @NSManaged public var notes: String?
    @NSManaged public var interactions: NSOrderedSet?

}

// MARK: Generated accessors for interactions
extension Person {

    @objc(insertObject:inInteractionsAtIndex:)
    @NSManaged public func insertIntoInteractions(_ value: Interaction, at idx: Int)

    @objc(removeObjectFromInteractionsAtIndex:)
    @NSManaged public func removeFromInteractions(at idx: Int)

    @objc(insertInteractions:atIndexes:)
    @NSManaged public func insertIntoInteractions(_ values: [Interaction], at indexes: NSIndexSet)

    @objc(removeInteractionsAtIndexes:)
    @NSManaged public func removeFromInteractions(at indexes: NSIndexSet)

    @objc(replaceObjectInInteractionsAtIndex:withObject:)
    @NSManaged public func replaceInteractions(at idx: Int, with value: Interaction)

    @objc(replaceInteractionsAtIndexes:withInteractions:)
    @NSManaged public func replaceInteractions(at indexes: NSIndexSet, with values: [Interaction])

    @objc(addInteractionsObject:)
    @NSManaged public func addToInteractions(_ value: Interaction)

    @objc(removeInteractionsObject:)
    @NSManaged public func removeFromInteractions(_ value: Interaction)

    @objc(addInteractions:)
    @NSManaged public func addToInteractions(_ values: NSOrderedSet)

    @objc(removeInteractions:)
    @NSManaged public func removeFromInteractions(_ values: NSOrderedSet)

}

extension Person : Identifiable {

}
extension Person: Comparable {
    public static func < (lhs: Person, rhs: Person) -> Bool {
        if let lhsInteractions = lhs.interactions {
            if let rhsInteractions = rhs.interactions {
                if lhsInteractions.count > 0 && rhsInteractions.count > 0 {
                    if let leftInteraction = lhsInteractions[0] as? Interaction {
                        if let rightInteraction = rhsInteractions[0] as? Interaction {
                            return leftInteraction.date < rightInteraction.date
                        }
                    }
                }
            }
        }
        return true
    }
}
