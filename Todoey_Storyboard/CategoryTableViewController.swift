//
//  CategoryTableViewController.swift
//  Todoey_Storyboard
//
//  Created by hazem smawy on 9/1/22.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController {
    var textField = UITextField()
    var catArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
     loadData()
    }
    //MAKE: - Add New Category
    @IBAction func addBtnPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            self.textField = alertTextField
        }
        let action = UIAlertAction(title: "add", style: .default) { action in
            let newCat = Category(context:self.context)
            newCat.name = self.textField.text!
            self.catArray.append(newCat)
            self.saveData()
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = catArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
    }
    
    //MARK: - mainublating data
    func loadData(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
        
      
        do {
            catArray = try context.fetch(request)
        }catch {
            print("there is error to retrive data from database")
        }
    }
    func saveData (){
        do {
            try context.save()
            print("data stored in database")
        }catch {
            print("there is error when store data to database")
        }
        tableView.reloadData()
    }


}
