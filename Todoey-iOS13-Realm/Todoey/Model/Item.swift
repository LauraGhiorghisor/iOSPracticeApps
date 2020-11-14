////
////  File.swift
////  Todoey
////
////  Created by Laura Ghiorghisor on 18/06/2020.
////  Copyright © 2020 App Brewery. All rights reserved.
////
//
import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    // reverse relationship
}

