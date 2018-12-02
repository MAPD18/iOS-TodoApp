//
//  TodoTaskCell.swift
//  TodoApp
//
//  Created by Rodrigo Silva on 2018-11-28.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import UIKit

class TodoTaskCell: UITableViewCell {

    
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
            if switchOutlet.isOn {
                switchOutlet.setOn(false, animated: true)
            } else {
                switchOutlet.setOn(true, animated: true)
            }
        }
    }

}
