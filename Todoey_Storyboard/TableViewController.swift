//
//  ViewController.swift
//  Todoey_Storyboard
//
//  Created by hazem smawy on 04/02/1444 AH.
//

import UIKit

class TableViewController: UITableViewController {
    var itemArray = [Item]()
    var titles = [String]()
    let defaults = UserDefaults.standard
    var textField = UITextField()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todoey"
        loadItems()
//        if let items  = defaults.array(forKey: "ToDoList") as? [Item] {
//           itemArray = items
//        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addItemBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Todo Item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            let newItem = Item()
            newItem.title = self.textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new item"
            self.textField = alertTextField
            
            
        }
       
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done  ? .checkmark : .none
        
        return cell
    }
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let item = itemArray[indexPath.row]
        item.done = !item.done
        saveItems()
        tableView.reloadData()
        
    }
    func  loadItems()  {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
                print(itemArray)
         
            }catch {
                print("error to load data")
            }
            
        }
        
    }
    func saveItems () {
        let ecoder = PropertyListEncoder()
        do {
            let data = try ecoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error when you store data to file \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
}

