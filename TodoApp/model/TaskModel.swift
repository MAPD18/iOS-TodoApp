//
//  Task.swift
//  TodoApp
//
//  Created by Rodrigo Silva on 2018-11-28.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import Foundation
import FirebaseFirestore

class TaskModel
{
    var documentId = ""
    var name = ""
    var checked = false
    var details = ""
    
    init(documentId: String, name: String, checked: Bool, details: String) {
        self.documentId = documentId
        self.name = name
        self.checked = checked
        self.details = details
    }
    
    convenience init(documentId: String, name: String, details: String) {
        self.init(documentId: documentId, name: name, checked: false, details: details)
    }
    
    convenience init(documentId: String, name: String, checked: Bool) {
        self.init(documentId: documentId, name: name, checked: checked, details: "details")
    }
    
    convenience init(document: QueryDocumentSnapshot) {
        self.init(documentId: document.documentID, name: document.get(AppConstants.TASK_NAME_FIELD) as! String, checked: document.get(AppConstants.TASK_CHECKED_FIELD) as! Bool, details: document.get(AppConstants.TASK_DETAILS_FIELD) as! String)
    }
}
