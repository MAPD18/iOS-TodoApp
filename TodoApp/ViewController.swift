//
//  ViewController.swift
//  TodoApp
//
//  Created by Rodrigo Silva on 2018-11-28.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks : [TaskModel] = [
        TaskModel(name: "Task 1", checked: true),
        TaskModel(name: "Task 2", checked: false),
        TaskModel(name: "Task 3", checked: true),
        TaskModel(name: "Task 4", checked: true),
        TaskModel(name: "Task 5", checked: false),
        ]
    
    enum TableSection: Int {
        case todo = 0, done = 1
    }
    
    let sectionHeaderHeight: CGFloat = 25
    
    var data = [TableSection: [TaskModel]]()
    
    func sortData() {
        data[.todo] = tasks.filter({$0.checked == false})
        data[.done] = tasks.filter({$0.checked == true})
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = TableSection(rawValue: section), let taskData = data[tableSection] {
            return taskData.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let tableSection = TableSection(rawValue: section), let taskData = data[tableSection], taskData.count > 0 {
            return sectionHeaderHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        view.backgroundColor = UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: sectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .todo:
                label.text = "To Do Tasks"
            case .done:
                label.text = "Done"
            }
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TodoTaskCell
        if let tableSection = TableSection(rawValue: indexPath.section), let task = data[tableSection]?[indexPath.row] {
            cell.taskLabel.text = task.name
            cell.switchOutlet.isOn = task.checked
        }
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sortData()
    }


}

