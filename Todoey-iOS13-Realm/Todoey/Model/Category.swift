//
//  Category.swift
//  Todoey
//
//  Created by Laura Ghiorghisor on 19/06/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = "No name provided"
    @objc dynamic var bgColor: String = "#FFFFFF"
    
    let items = List<Item>()
    // so cool  - that is an arrat of ints
    // but list is a class of realm
    // the inverse relationship is not defined automatically as is with core data  - the parentCategort thing
}
