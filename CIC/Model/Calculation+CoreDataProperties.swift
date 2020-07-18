//
//  Calculation+CoreDataProperties.swift
//  CIC
//
//  Created by Данила on 28.05.2020.
//  Copyright © 2020 Данила. All rights reserved.
//
//

import Foundation
import CoreData


extension Calculation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calculation> {
        return NSFetchRequest<Calculation>(entityName: "Calculation")
    }

    @NSManaged public var frequency: Int16
    @NSManaged public var time: Int16
    @NSManaged public var capital: Double
    @NSManaged public var initialCapital: Double
    @NSManaged public var lotPrice: Double
    @NSManaged public var percent: Double
    @NSManaged public var currency: String?

}
