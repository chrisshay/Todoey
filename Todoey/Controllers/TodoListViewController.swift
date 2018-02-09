//
//  ViewController.swift
//  Todoey
//
//  Created by Christopher Shayler on 02/02/2018.
//  Copyright © 2018 Christopher Shayler. All rights reserved.
//  This now uses core data db
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //this prints the path of where our data will be stored
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }

    //MARK: - tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        let item = itemArray[indexPath.row]
        
        cell?.textLabel?.text = item.title
        //set the checkmark using ternary operator value = condition ? valueiftrue : value if false
        cell?.accessoryType = item.done ? .checkmark : .none
        
        return cell!
        
    }

    //MARK: - tableview delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].title!)
        
        //swap the check mark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //uncomment thisif you want to delete the items when clicked on instead of showing checkmark
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //save to context changes to items to persistent container so change to check marks are persisted
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    //show ui alert controller with a text feild to add item to the list
    
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add item button on ui alert
            
            //add item to core data

            let newItem = Item(context: self.context)
            newItem.title = textFeild.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)

            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textFeild = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveItems(){
        //save to core data
        
        do{
           try context.save()
        }catch{
            print("Error saving to core data, \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //funciton has a default to get all- wll get all if you do not call with a request item
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){

        //use predicate to load items of correct category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
   
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }

        
        do{
            itemArray = try context.fetch(request)
            
        }catch{
            print("Error fetching data from context \(error)")
        }
    }
}

//MARK: - Search Bar Methods
//extend the base view controller instead of adding all delegates at the top
extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text!)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //use NSPredicate to query the data in the database
        //
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //%@ means to look at the args passed in i.e searchbar.text
        
        //sort the results
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
        //update array with results
        loadItems(with: request, predicate: predicate)
        
        tableView.reloadData()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                //to get rid of keyboard
                searchBar.resignFirstResponder()
            }
            tableView.reloadData()
        }
    }

}

