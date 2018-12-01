//
//  Task.swift
//  TodoApp
//
//  Created by Rodrigo Silva on 2018-11-28.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import Foundation

class TaskModel
{
    var name = ""
    var checked = false
    
    convenience init(name : String) {
        self.init(name: name, checked: false)
    }
    
    init(name: String, checked: Bool) {
        self.name = name
        self.checked = checked
    }
}
