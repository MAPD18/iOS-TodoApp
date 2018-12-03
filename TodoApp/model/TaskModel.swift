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
    var details = ""
    
    convenience init(name: String, details: String) {
        self.init(name: name, checked: false, details: details)
    }
    
    init(name: String, checked: Bool, details: String) {
        self.name = name
        self.checked = checked
        self.details = details
    }
    
    convenience init(name: String, checked: Bool) {
        self.init(name: name, checked: checked, details: "details")
    }
}
