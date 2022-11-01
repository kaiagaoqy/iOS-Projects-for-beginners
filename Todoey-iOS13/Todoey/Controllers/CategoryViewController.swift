//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kaia Gao on 10/29/22.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories: Results<Category>? // Results is an auto-updating container type in Realm returned from object queries.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories() //load all Categories
        tableView.separatorStyle = .none
    
    }
    override func viewWillAppear(_ animated: Bool) {
            guard let navBar = navigationController?.navigationBar else{
                fatalError("Navigation controller does not exist")
            }
            let defaultColor = UIColor(hexString: "FFFFFF")!
            navBar.backgroundColor = defaultColor
            navBar.tintColor = ContrastColorOf(defaultColor, returnFlat: true)
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(defaultColor, returnFlat: true)]
    }
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // if add this, no categories will be showed
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // user super class to create cell
        let cell = super.tableView(tableView,cellForRowAt:indexPath)
        let currentCategory = categories?[indexPath.row]
        guard let categoryColor = UIColor(hexString: currentCategory?.color ?? "1D98F6") else {fatalError("Category color ")}
        cell.textLabel?.text = currentCategory?.name ?? "No Category added"
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        return cell
    }

    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // trigger the segue
        performSegue(withIdentifier: "gotoItems", sender: self) // self: CategoryVC means let CategoryVC initiate its seague with specified identifier "gotoItems"
        
    }
    
    /**
     Notify the VC that a seqgue is about to perform
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController //destination VC
        // grab the category that corresponds to the seleted cell
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
        
    }
    // MARK: - TableView Delegate Methods
    
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Saving Categories error: \(error)")
        }
        
        tableView.reloadData() // reload data from container to current table view because of newly stored data
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self) // load in all categories
        tableView.reloadData()
    }

    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                    
                }
            }catch{
                print("Error deleting category,\(error)")
            }
            //tableView.reloadData()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() // refer to the locol variable of text field
        
        // Pop up an alert
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert) // .alert == UIAlertController.alert
        
        // Add a button and Apply the default style to the action button when the user taps a button in an alert.
        let action = UIAlertAction(title: "Add Category", style: .default){
            (action) in
            // closure: What will happen once the user clicks the Add Item on our UIAlert

            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            //self.categories.append(newCategory) // no need! it's aoto-update
            
            self.saveCategories(category:newCategory)
            
            // Reload the data to show new items
            self.tableView.reloadData()
        }
        
        // add a textfield
        alert.addTextField{
            // Trigger the closure only when the text field is added to the alert
            (alertTextField) in alertTextField.placeholder = "Create a new Category"
            // ! Extend the scope of alertTextField to the whole function
            textField = alertTextField // textField has a scope of entile addButtonPressed function while the alertTextField only has it inside the closure
            
        }
        // attach the action object to the alert
        alert.addAction(action)
        
        // present the alert view controller
        present(alert, animated: true, completion: nil)
        
    }
}

