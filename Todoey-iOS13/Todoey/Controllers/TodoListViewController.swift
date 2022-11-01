//
//  ViewController.swift
//  Todoey
//
//  Created by Kaia Gao on 11/1/22.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    
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
        tableView.separatorStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color{
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else{
                fatalError("Navigation controller does not exist")
            }
            if let navBarColor = UIColor(hexString: colorHex){
                navBar.backgroundColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                searchBar.barTintColor = navBarColor
                searchBar.backgroundColor = navBarColor
                
//                let appearance = UINavigationBarAppearance()
//                appearance.configureWithOpaqueBackground()
//                appearance.backgroundColor = navBarColor // your colour here
//
//                navigationController?.navigationBar.standardAppearance = appearance
//                navigationController?.navigationBar.scrollEdgeAppearance = appearance
                
            }
            
        }
    }
    
    // MARK: -- Table View Data Source Method
    // numberOfRowsInSection: Tells the data source to return the number of rows in a given section of a table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a resuable cell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            // Mark -- Terbary Operator
            // value = condition ? valueIfTrue : valueIfFalse
            // Render cell's accessory type based on 'done' property of each item
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)){ // Can not be whole/whole --> whole number = 0
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            

        }else{
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(itemForDeletion)
                    
                }
            }catch{
                print("Error deleting item,\(error)")
            }
            //tableView.reloadData()
        }
    }
    
    // MARK: -- Table View Delegate Method
    // didSelectRowAt: tell the delegate a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row) // 0, 1, 2
        // Change the status once users click the item
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                    tableView.reloadData()
                }
            }catch{
                print("Error savinf done item, \(error)")
            }
        }
    
        
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
            
            // Append the item to its category
            if let currentCategory = self.selectedCategory{
                do{try self.realm.write{
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                   }
                }
                catch{
                    print("Error saving new items. \(error)")
                }
            }
            
        
            
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
    
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
    }
    
    
}

// MARK: search bar method
// use extension keyword to split functions
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath:"dateCreated",ascending: true)
        
        tableView.reloadData()
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
