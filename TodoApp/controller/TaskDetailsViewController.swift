//
//  CreateTaskViewController.swift
//  TodoApp
//
//  Created by Rodrigo Silva on 2018-12-01.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import UIKit

protocol SaveTaskListener {
    func saveTask(name: String, details: String)
    func saveTask(selectedTask: SelectedTask)
}

class TaskDetailsViewController: UIViewController {

    var delegate : SaveTaskListener?
    var selectedTask: SelectedTask?
    
    @IBOutlet weak var taskNameOutlet: UITextField!
    @IBOutlet weak var taskDetailsOutlet: UITextField!
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        if selectedTask != nil {
            selectedTask?.task?.name = taskNameOutlet!.text!
            selectedTask?.task?.details = taskDetailsOutlet!.text!
            delegate?.saveTask(selectedTask: selectedTask!)
        } else {
            delegate?.saveTask(name: taskNameOutlet!.text!, details: taskDetailsOutlet!.text!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedTask != nil {
            taskNameOutlet.text = selectedTask?.task?.name
            taskDetailsOutlet.text = selectedTask?.task?.details
        }
        
    }
    
    @IBAction func onCancelButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
