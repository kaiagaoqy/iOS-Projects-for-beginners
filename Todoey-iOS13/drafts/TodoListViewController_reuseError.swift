//
//  ViewController.swift
//  Todoey
//
//  Created by Kaia Gao on 29/10/2022.
//

import UIKit

class TodoListViewController: UITableViewController {
    // Mark -- hard-coded items
    var itemArray = ["Buy Milk", "hand in proposal", "develop an app"]
    let defaults = UserDefaults.standard// link to the user's default database save data to .plist file in a format "Key-Type-Value"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Mark -- usage for "as"
        /**
         as: Upcasts(向上转型)
         as!: Mandatory Downcasting(强制类型转换), trigger "runtime" error if fail to converse data type
         as?: same as "as!", but return nil if fail. optional object if succeed
         */
       if let items = defaults.array(forKey: "TodoListArray") as? [String]{
           itemArray = items
       }
        
        
    }
    
    // Mark -- Table View Data Source Method
    // numberOfRowsInSection: Tells the data source to return the number of rows in a given section of a table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a resuable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       cell.textLabel?.text = itemArray[indexPath.row] // row value of current cell

        return cell
    }
    
    // Mark -- Table View Delegate Method
    // didSelectRowAt: tell the delegate a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row) // 0, 1, 2
        
        
        
       if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark // return the table cell at specified indexPath, then set its accessoryType as checked
       {tableView.cellForRow(at: indexPath)?.accessoryType = .none}
       else{
           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
       }
        
        
        tableView.deselectRow(at: indexPath, animated: true) // select then deselect
        
    }
    
    // Mark -- Add New Items]
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() // refer to the locol variable of text field
        
        // Pop up an alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert) // .alert == UIAlertController.alert
        
        // Add a button and Apply the default style to the action button when the user taps a button in an alert.
        let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            // closure: What will happen once the user clicks the Add Item on our UIAlert
            //print(textField.text)
            
            // Append the item into itemArray          
            self.itemArray.append(textField.text!) // specify it as TodoListViewController.itemArray
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray") // save key-value pair to user default database
            
            // Reload the data to show new items
            self.tableView.reloadData()
        }
        
        // add a textfield
        alert.addTextField{
            // Trigger the closure only when the text field is added to the alert
            (alertTextField) in alertTextField.placeholder = "Create a new item"
            // ! Extend the scope of alertTextField to the whole function
            textField = alertTextField // textField has a scope of entile addButtonPressed function while the alertTextField only has it inside the closure
            
            // print(alertTextField.text) // empty!!!
        }
        // attach the action object to the alert
        alert.addAction(action)
        
        // present the alert view controller
        present(alert, animated: true, completion: nil)
    }
    
}

