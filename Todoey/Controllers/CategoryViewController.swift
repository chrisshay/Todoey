//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Christopher Shayler on 09/02/2018.
//  Copyright © 2018 Christopher Shayler. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()

    }

    //MARK: - Tableview datasource Methods
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")

        cell?.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell!
    }
    
    
    //MARK: - Data manipulation methods
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){

        do{
            categoryArray = try context.fetch(request)
            
        }catch{
            print("Error fetching data from context \(error)")
        }
    }
    
    func saveCategories(){
        //save to core data
        
        do{
            try context.save()
        }catch{
            print("Error saving to core data, \(error)")
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
            
            //add item to core data
            
            let newCat = Category(context: self.context)
            newCat.name = textFeild.text!

            self.categoryArray.append(newCat)
            
            self.saveCategories()
            
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
                destinatonVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }

}
