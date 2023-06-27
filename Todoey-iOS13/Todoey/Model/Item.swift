//
//  data.swift
//  Todoey
//
//  Created by Kaia Gao on 11/1/22.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // Set inverse relationship comes from Category's property called "items"
}
