//
//  Category.swift
//  Todoey
//
//  Created by Kaia Gao on 11/1/22.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = "" //dynamically update the value in database while the app is running , which is a concept comes from objective-c
    @objc dynamic var color: String = ""
    let items = List<Item>() // Realm to define -to-many relationship and initilize it as an empty list
    
}
