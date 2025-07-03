//
//  TodoListFireStoreViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 08/10/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TodoListFireStoreViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var todos: [ToDoItem] = []
    var db: Firestore?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        db = Firestore.firestore()
        fetchTodos()
    }
    
    func setup() {
        addButton.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
        let nib = UINib(nibName: "ChartItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChartItemTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func actionTap() {
        self.addShowPersonAlert()
    }
    
    func fetchTodos() {
        if let db = db  {
            db.collection("todos").addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else {
                    self.todos = querySnapshot?.documents.compactMap({ (document) -> ToDoItem? in
                        return ToDoItem(dictionary: document.data())
                    }) ?? []
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    
}

extension TodoListFireStoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartItemTableViewCell", for: indexPath) as? ChartItemTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(data: todos[indexPath.row] )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        shoewEditAlert(idx: index)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todoID = self.todos[indexPath.row].id
            self.db?.collection("todos").document(todoID).delete { error in
                if let error = error {
                    print("Error removing document: \(error.localizedDescription)")
                } else {
                    print("Document successfully removed!")
                    
                    // Remove the item from the local data source
                    if indexPath.row < self.todos.count {
                        // Remove the todo from the local data source
                        self.todos.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    } else {
                        print("Invalid index path: \(indexPath.row) exceeds bounds")
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    
    
}

// MARK: Editing and Add with Alert
extension TodoListFireStoreViewController {
    
    func addShowPersonAlert() {
        let alertController = UIAlertController(title: "Edit Your Name", message: "Please enter your name below:", preferredStyle: .alert)
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Masukan Title Task"
        }
        
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Masukan Deskripsi Task"
        }
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Durasi Pengerjaan"
        }
        
        // Add an action for "OK" button
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            if let title = alertController?.textFields?[0].text,
               let description = alertController?.textFields?[1].text,
               let duration = alertController?.textFields?[2].text {
                
                let newTodo = ToDoItem(id: UUID().uuidString, title: title, description: description, time: "time" , duration: Int(duration) ?? 0, status: "todo", userID: Auth.auth().currentUser?.uid ?? "")
                
                self.db?.collection("todos").document(newTodo.id).setData(newTodo.dictionary) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added with ID: \(newTodo.id)")
                        self.fetchTodos()
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        // Add an action for "Cancel" button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    func shoewEditAlert(idx: Int) {
        let alertController = UIAlertController(title: "Edit Your Name", message: "Please enter your name below:", preferredStyle: .alert)
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.text = self.todos[idx].title
        }
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Description"
            textField.text = self.todos[idx].description
        }
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Duration"
            textField.text = String(self.todos[idx].duration)
        }
        
        // Add an action for "OK" button
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            if let name = alertController?.textFields?[0].text,
               let desc = alertController?.textFields?[1].text,
               let duration = alertController?.textFields?[2].text {
                self.db?.collection("todos")
                    .document(self.todos[idx].id)
                    .updateData(["title": name,
                                 "description": desc,
                                 "duration" : Int(duration) ?? 0]) { error in
                        if let error = error {
                            print("Error updating status: \(error)")
                        } else {
                            self.fetchTodos() // Refresh the list
                        }
                    }
                self.tableView.reloadData()
            }
        }
        
        // Add an action for "Cancel" button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
}

