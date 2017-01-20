//
//  ViewController.swift
//  TodoList
//
//  Created by imac on 18.12.16.
//  Copyright © 2016 imac. All rights reserved.
//

import UIKit
import CoreData
import Toast_Swift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: VIEW PROPERTIES
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: DATA PROPERTIES
    
    var managedContext : NSManagedObjectContext!
    var tasks = [NSManagedObject]()
    var alertController : UIAlertController?
    var confirmAction : UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Remove redundant dividers
        tableView.tableFooterView = UIView()
        
        createAddItemAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            let results = try managedContext.fetch(request)
            tasks = results 
            print(tasks.count)
        } catch {
            print(error)
        }
    }
    
    func createAddItemAlert() {
        
        alertController = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        alertController?.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "Task title"
            textField.addTarget(self, action: #selector(self.titleChanged(_:)), for: .editingChanged)
        })
        alertController?.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "Task Description"
        })
        
        confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: ({
            (_) in
            let title = self.alertController?.textFields?[0].text
            let description = self.alertController?.textFields?[1].text
            self.saveItem(title: title, description: description)
            self.clearAlertFields()
        }))
        confirmAction?.isEnabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: ({(_) in self.clearAlertFields()}))
        
        alertController?.addAction(confirmAction!)
        alertController?.addAction(cancelAction)
    }
    
    func clearAlertFields() {
        self.alertController?.textFields?[0].text = ""
        self.alertController?.textFields?[1].text = ""
    }
    
    func titleChanged(_ textField: UITextField) {
        print(textField.text)
        confirmAction?.isEnabled = !textField.text!.isEmpty
    }
    
    func saveItem(title: String?, description : String?) {
        
        let entity = NSEntityDescription.entity(forEntityName: "TaskEntity", in: managedContext)
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(title, forKey: "taskTitle")
        item.setValue(description, forKey: "taskDescription")
        item.setValue(Date(), forKey: "createdAt")
        
        do {
            try managedContext.save()
            tasks.append(item)
            tableView.reloadData()
            self.view.makeToast("Task was created")
        } catch {
            print(error)
        }
    }

    //MARK: ACTIONS
    
    @IBAction func addButtonClicked(_ sender: AnyObject) {
        if let alert = alertController {
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: TABLE VIEW FUNCTIONS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let entity = tasks[indexPath.row] as! TaskEntity
        item.titleLabel.text = entity.taskTitle
        item.descriptionLabel.text = entity.taskDescription
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEE, MMM d, ''yy"
        let dateString = dayTimePeriodFormatter.string(from: entity.createdAt as! Date)
        
        item.dateLabel.text = dateString

        return item
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let currentItem = tasks[indexPath.row]
            managedContext.delete(currentItem)
            do {
                try managedContext.save()
                tasks.remove(at: indexPath.row)
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
}

