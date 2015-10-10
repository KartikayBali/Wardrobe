//
//  Bookmark.swift
//  SuperWardrobe
//
//  Created by Kartikay bali on 10/10/15.
//  Copyright (c) 2015 Kartikay bali. All rights reserved.
//

import Foundation
import CoreData

@objc(Bookmark)
class Bookmark: NSManagedObject {

    @NSManaged var recordID: NSNumber
    @NSManaged var lowerWear: LowerWear
    @NSManaged var upperWear: UpperWear

}
