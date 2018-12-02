//
//  TodoTaskCell.swift
//  TodoApp
//
//  Created by Rodrigo Silva on 2018-11-28.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import UIKit

protocol TaskStatusChangeListener {
    func onTaskStatusChange(checked: Bool, section: Int, index: Int)
}

class TodoTaskCell: UITableViewCell {

    var delegate : TaskStatusChangeListener?
    var index : Int?
    var section : Int?
    var tasks : [TaskModel]?
    
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet weak var taskLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Grey color for the DONE Tasks
        switchOutlet.onTintColor = UIColor.gray
        
        // Green color for the TODO Tasks
        switchOutlet.tintColor = UIColor.green
        switchOutlet.layer.cornerRadius = switchOutlet.frame.height / 2
        switchOutlet.backgroundColor = UIColor.green
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
