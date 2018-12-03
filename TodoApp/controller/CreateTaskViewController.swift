//
//  CreateTaskViewController.swift
//  TodoApp
//
//  Created by Rodrigo Silva on 2018-12-01.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import UIKit

protocol AddTaskListener {
    func addTask(name: String)
}

class CreateTaskViewController: UIViewController {

    var delegate : AddTaskListener?
    
    @IBOutlet weak var taskNameOutlet: UITextField!
    
    @IBAction func onAddButtonClicked() {
        delegate?.addTask(name: taskNameOutlet!.text!)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
