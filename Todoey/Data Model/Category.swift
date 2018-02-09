//
//  Category.swift
//  Todoey
//
//  Created by Christopher Shayler on 09/02/2018.
//  Copyright © 2018 Christopher Shayler. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
