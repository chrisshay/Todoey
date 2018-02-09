//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Christopher Shayler on 09/02/2018.
//  Copyright © 2018 Christopher Shayler. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()

    }

    //MARK: - Tableview datasource Methods
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")

        cell?.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        return cell!
    }
    
    
    //MARK: - Data manipulation methods
    func loadCategories(){

        categories = realm.objects(Category.self)

    }
    
    func save(category: Category){
        //save to core data
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving to realm, \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Add new categories


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //show ui alert controller with a text feild to add item to the list
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen when user clicks add item button on ui alert
            
            //add item to realm
            
            let newCat = Category()
            newCat.name = textFeild.text!
            
            self.save(category: newCat)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textFeild = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when cat selected trigger seque
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinatonVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
                destinatonVC.selectedCategory = categories?[indexPath.row]
        }
        
    }

}
