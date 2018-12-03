//
//  ViewController.swift
//  TodoApp
//
//  Created by Rodrigo Silva on 2018-11-28.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveTaskListener, TaskListener {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum TableSection: Int {
        case todo = 0, done = 1
    }
    
    let sectionHeaderHeight: CGFloat = 25
    var db : Firestore?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var data = [TableSection: [TaskModel]]()
    
    func saveTask(selectedTask: SelectedTask) {
        db?.collection(AppConstants.FIREBASE_BASE_PATH).document((selectedTask.task?.documentId)!).setData([
            AppConstants.TASK_NAME_FIELD : selectedTask.task?.name as Any,
            AppConstants.TASK_DETAILS_FIELD : selectedTask.task?.details as Any,
            AppConstants.TASK_CHECKED_FIELD: selectedTask.task?.checked as Any
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                let updatedTask = self.data[TableSection(rawValue: selectedTask.section!)!]?[selectedTask.index!]
                updatedTask?.name = (selectedTask.task?.name)!
                updatedTask?.details = (selectedTask.task?.details)!
                
                self.tableView.reloadSections([selectedTask.section!], with: .automatic)
            }
        }
    }
    
    func saveTask(name: String, details: String) {
        var ref: DocumentReference? = nil
        ref = db?.collection(AppConstants.FIREBASE_BASE_PATH).addDocument(data: [
            AppConstants.TASK_NAME_FIELD : name,
            AppConstants.TASK_DETAILS_FIELD : details,
            AppConstants.TASK_CHECKED_FIELD: false
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.data[.todo]?.append(TaskModel(documentId: ref!.documentID, name: name, details: details))
                self.tableView.reloadSections([TableSection.todo.rawValue], with: .automatic)
            }
        }
    }
    
    func onTaskSelected(section: Int, index: Int) {
        performSegue(withIdentifier: "saveTaskSegue", sender: SelectedTask(task: (data[TableSection(rawValue: section)!]?[index])!, section: section, index: index))
    }
    
    func onTaskStatusChange(checked: Bool, section: Int, index: Int) {
        let tableSection = TableSection(rawValue: section)!
        let task = data[tableSection]![index]
        
        db?.collection(AppConstants.FIREBASE_BASE_PATH).document(task.documentId).setData([
            AppConstants.TASK_CHECKED_FIELD: checked as Any
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                task.checked = checked
                
                if tableSection == TableSection.done {
                    self.data[.done]?.remove(at: index)
                    self.data[.todo]?.append(task)
                } else {
                    self.data[.todo]?.remove(at: index)
                    self.data[.done]?.append(task)
                }
                
                self.tableView.reloadSections([TableSection.todo.rawValue, TableSection.done.rawValue], with: .automatic)
            }
        }
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
        view.backgroundColor = UIColor(red: 90.0/255.0, green: 200.0/255.0, blue: 250.0/255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: sectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.white
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
        
        cell.delegate = self
        cell.index = indexPath.row
        cell.section = indexPath.section
        cell.tasks = data[TableSection(rawValue: indexPath.section)!]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [deleteAction(at: indexPath)])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == TableSection.todo.rawValue {
            return UISwipeActionsConfiguration(actions: [completeTaskAction(at: indexPath)])
        }
        return nil
    }
    
    func completeTaskAction(at indexPath: IndexPath) -> UIContextualAction {
        let completeTaskAction = UIContextualAction(style: .normal, title: "Complete") { (action, view, completion) in
            if TableSection(rawValue: indexPath.section) != nil {
                self.onTaskStatusChange(checked: true, section: indexPath.section, index: indexPath.row)
            }
            completion(true)
        }
        completeTaskAction.backgroundColor = .green
        return completeTaskAction
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            if let tableSection = TableSection(rawValue: indexPath.section) {
                let taskDocumentId = self.data[tableSection]?[indexPath.row].documentId
                self.db?.collection(AppConstants.FIREBASE_BASE_PATH).document(taskDocumentId!).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        self.data[tableSection]?.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            completion(true)
        }
        
        deleteAction.backgroundColor = .red
        return deleteAction
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        loadTasks()
    }
    
    func loadTasks() {
        data[.todo] = []
        data[.done] = []
        
        db?.collection(AppConstants.FIREBASE_BASE_PATH).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let task = TaskModel(document: document)
                    let tableSection = TableSection(rawValue: task.checked ? 1 : 0)!
                    self.data[tableSection]?.append(task)
                    self.tableView.reloadSections([tableSection.rawValue], with: .automatic)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? TaskDetailsViewController
        
        let selectedTask = sender as? SelectedTask
        if selectedTask != nil {
            vc?.selectedTask = selectedTask
        }
        
        vc?.delegate = self
    }
}

class SelectedTask {
    var task: TaskModel?
    var section: Int?
    var index: Int?
    
    init(task: TaskModel, section: Int, index: Int) {
        self.task = task
        self.section = section
        self.index = index
    }
}

