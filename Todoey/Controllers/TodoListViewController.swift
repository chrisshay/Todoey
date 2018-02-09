//
//  ViewController.swift
//  Todoey
//
//  Created by Christopher Shayler on 02/02/2018.
//  Copyright © 2018 Christopher Shayler. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        //load the saved array from user preferences
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
        }
    }

//MARK - tableview datasource methods
    
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

//MARK - tableview delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].title)
        
        //swap the check mark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
//MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    //show ui alert controller with a text feild to add item to the list
    
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add item button on ui alert
            //add text to item array
            let newItem = Item()
            newItem.title = textFeild.text!
            
            self.itemArray.append(newItem)
            //save updated item array to user defaults
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textFeild = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}

