//
//  ViewController.swift
//  Todoey_Storyboard
//
//  Created by hazem smawy on 04/02/1444 AH.
//

import UIKit
import RealmSwift
class TableViewController: UITableViewController {
    var todoItem :Results<CategoryItem>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    //let defaults = UserDefaults.standard
    var textField = UITextField()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func addItemBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Todo Item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            
            let newItem = CategoryItem()
          
            if let curerentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                        
                        newItem.title = self.textField.text!
                        newItem.dataCreatedAt = Date()
                        curerentCategory.items.append(newItem)
                        
                    })
                }catch {
                    print("there is some error to store data")
                }
               

            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new item"
            self.textField = alertTextField
            
            
        }
       
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        cell.textLabel?.text = todoItem?[indexPath.row].title ?? "no items here"
        
        if let item = todoItem?[indexPath.row] {
            cell.accessoryType = item.done  ? .checkmark : .none
        }
        
        return cell
    }
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItem?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                })
            }catch  {
                print("Error saving done status, \(error)")
            }
          
        }

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    func  loadItems()  {

        todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }

    
   
  
    
}
// MARK - search bar
extension  TableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath:"dataCreatedAt", ascending: false)
      
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
    
    
}
