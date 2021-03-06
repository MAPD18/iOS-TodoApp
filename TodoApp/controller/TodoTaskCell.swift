//
//  TodoTaskCell.swift
//  TodoApp
//
//  Created by Rodrigo Silva on 2018-11-28.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import UIKit

protocol TaskListener {
    func onTaskStatusChange(checked: Bool, section: Int, index: Int)
    func onTaskSelected(section: Int, index: Int)
}

class TodoTaskCell: UITableViewCell {

    var delegate : TaskListener?
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
        if selected {
            delegate?.onTaskSelected(section: section!, index: index!)
        }
    }

    @IBAction func onTaskStatusChange() {
        delegate?.onTaskStatusChange(checked: switchOutlet.isOn, section: section!, index: index!)
    }
}
