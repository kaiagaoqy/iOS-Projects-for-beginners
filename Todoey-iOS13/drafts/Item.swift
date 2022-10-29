//
//  Item.swift
//  Todoey
//
//  Created by Kaia Gao on 10/29/22.
//

import Foundation

class Item: Codable{ // Codable == Encodable & Decodable
    var title: String = ""
    var done: Bool = false
}
