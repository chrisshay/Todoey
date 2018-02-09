//
//  ViewController.swift
//  Todoey
//
//  Created by Christopher Shayler on 02/02/2018.
//  Copyright © 2018 Christopher Shayler. All rights reserved.
//  This now uses core data db
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //this prints the path of where our data will be stored
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }

    //MARK: - tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        
        if let item = toDoItems?[indexPath.row]{
            
            cell?.textLabel?.text = item.title
            //set the checkmark using ternary operator value = condition ? valueiftrue : value if false
            cell?.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell?.textLabel?.text = "No Items Added"
        }

        return cell!
        
    }

    //MARK: - tableview delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //swap the check mark
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error writing done status")
            }
        }
        
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
            
            //add item to core realm

            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.done = false
                        newItem.title = textFeild.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving to realm, \(error)")
                }
            }
            
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

    func loadItems(){
        //now uses realm db
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
//extend the base view controller instead of adding all delegates at the top
extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        print(searchBar.text!)
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

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


