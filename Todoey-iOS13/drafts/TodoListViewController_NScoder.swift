//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    // Mark -- hard-coded items
    //var itemArray = ["Buy Milk", "hand in proposal", "develop an app"]
    var itemArray = [Item]() // an array stroes Item objects
//    let defaults = UserDefaults.standard// link to the user's default database save data to .plist file in a format "Key-Type-Value"
    
    // Search for a directory in a requested domain, then add a new component, "Item.plist", to that directory and return the component's url
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Mark -- usage for "as"
        /**
         as: Upcasts(向上转型)
         as!: Mandatory Downcasting(强制类型转换), trigger "runtime" error if fail to converse data type
         as?: same as "as!", but return nil if fail. optional object if succeed
         */
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        
//        let newItem = Item()
//        newItem.title = "Buy Milk"
//        itemArray.append(newItem)
        
        loadItems()
    }
    
    // Mark -- Table View Data Source Method
    // numberOfRowsInSection: Tells the data source to return the number of rows in a given section of a table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a resuable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Mark -- Terbary Operator
        // value = condition ? valueIfTrue : valueIfFalse
        // Render cell's accessory type based on 'done' property of each item
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    // Mark -- Table View Delegate Method
    // didSelectRowAt: tell the delegate a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row) // 0, 1, 2
        // Change the status once users click the item
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems() // update .plist once items are changed
        
        //tableView.reloadData() // reload datasouce to update its "done" property
        
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
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem) // specify it as TodoListViewController.itemArray
            
            self.saveItems()
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray") // save key-value pair to user default database
            
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
    
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray) // return an encoded value
            try data.write(to: dataFilePath!) // write encoded value to requested file path
        } catch{
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                // decode data from a property list using a requested format
                itemArray = try decoder.decode([Item].self, from: data) // use ".self" to reference the type object instead of only a type name if we are not specifying object
            }catch{
                print("Error decoding plist, \(error)")
            }
        }
    }
}

