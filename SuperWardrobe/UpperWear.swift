//
//  UpperWear.swift
//  SuperWardrobe
//
//  Created by Kartikay bali on 10/10/15.
//  Copyright (c) 2015 Kartikay bali. All rights reserved.
//

import Foundation
import CoreData

@objc(UpperWear)
class UpperWear: NSManagedObject {

    @NSManaged var recordID: NSNumber
    @NSManaged var type: String
    @NSManaged var image: NSData
    @NSManaged var bookmark: NSSet

}
