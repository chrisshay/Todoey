//
//  item.swift
//  Todoey
//
//  Created by Christopher Shayler on 08/02/2018.
//  Copyright © 2018 Christopher Shayler. All rights reserved.
// items are saved to an items plist file
//

import Foundation

class Item: Codable{
    
    var title: String = ""
    var done: Bool = false
    
}
