//
//  Pokemons+CoreDataProperties.swift
//  Checklists
//
//  Created by Farhan Molla on 12/7/22.
//
//

import Foundation
import CoreData


extension Pokemons {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pokemons> {
        return NSFetchRequest<Pokemons>(entityName: "Pokemons")
    }

    @NSManaged public var name: String?
    @NSManaged public var height: Int16
    @NSManaged public var weight: Int16
    @NSManaged public var types: String?
    @NSManaged public var image: String?

}

extension Pokemons : Identifiable {

}
