//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    // MARK: -- hard-coded items
    //var itemArray = ["Buy Milk", "hand in proposal", "develop an app"]
    var itemArray = [Item]() // an array stroes Item objects
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // go to delegate to grab persistent container
    // MARK: Set property to be controlled by segue
    var selectedCategory : Category?{
        didSet{
            // get triggered once the optional is set a vaalue
            loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        searchBar.delegate = self
        
        loadItems()
    }
    
    // MARK: -- Table View Data Source Method
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
    
    // MARK: -- Table View Delegate Method
    // didSelectRowAt: tell the delegate a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row) // 0, 1, 2
        // Change the status once users click the item
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems() // update .plist once items are changed
        
        /**delete
         context.delete(itemArray[indexPath.row]) // 1. remove the data from context
         itemArray.remove(at: indexPath.row)  // 2. remove the item from itemArray to load up table view data source
         
         self.saveItems() // 3. update to persistant container
         **/
        
        tableView.deselectRow(at: indexPath, animated: true) // select then deselect
        
    }
    
    // MARK: - Add New Items
    
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
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false // must be initiate if set as "required"
            newItem.parentCategory = self.selectedCategory //MARK: set data relationship
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
        
        do{
            try context.save() // save current context to container
        } catch{
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil){ // set a default value
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        request.predicate = predicte
        // Use compound predicate to avoid overwriting predicate for a request
        if let additionPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionPredicate,categoryPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        
        do{
            itemArray = try context.fetch(request) // load up to container
        } catch{
            print("Error fetching context, \(error)")
        }
    }
    
    
}

// MARK: search bar method
// use extension keyword to split functions
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest() //search criteria used to retrieve data from a persistent store for "Item" entity.
        
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!) // How we want to query our database -->  logical conditions for constraining a search for a fetch
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) // order a collection of items according to the "title" property
        request.sortDescriptors = [sortDescriptor] // an array of descriptor to sort the items
        loadItems(with: request,predicate: predicate)

        
        tableView.reloadData() // reload data satisfying the fetch request’s critieria.
        
    }
    
    /**
     Tell the delegate that the user change the search text
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{ // search bar is cleared
            loadItems() // fetch all items
            
            // Go back to the original state: dismiss the cursor and keyboard
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // stop the search bar being the first responder(currently selected)
            }
            
        }
    }
}
