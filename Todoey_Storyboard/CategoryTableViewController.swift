//
//  CategoryTableViewController.swift
//  Todoey_Storyboard
//
//  Created by hazem smawy on 9/1/22.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    var realm = try! Realm()
    
    var textField = UITextField()
    var categoreis:Results<Category>?
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    //MAKE: - Add New Category
    @IBAction func addBtnPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            self.textField = alertTextField
        }
        let action = UIAlertAction(title: "add", style: .default) { action in
            let newCat = Category()
            
            newCat.name = self.textField.text!
            
            self.saveCategory(category:newCat)
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoreis?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoreis?[indexPath.row].name ?? "NO CATEGORY HERE"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoreis?[indexPath.row]
        }
    }
    
    //MARK: - mainublating data
    func loadCategory() {
         categoreis = realm.objects(Category.self)
    }
    func saveCategory (category:Category){
        do {
            try realm.write({
                realm.add(category)
            })
            print("data stored in database")
        }catch {
            print("there is error when store data to database")
        }
        tableView.reloadData()
    }


}
