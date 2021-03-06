//
//  NotesListTableViewController.swift
//  kitbykirti
//
//  Created by Appy on 10/02/20.
//  Copyright © 2020 Appy. All rights reserved.
//

import UIKit
import Firebase

class NotesListTableViewController: UITableViewController {
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    // MARK: Properties
    var items: [NotesItem] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    let ref = Database.database().reference(withPath: "NotesList")
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        userCountBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "backArrow"), style: .plain, target: self, action: #selector(userCountButtonDidTouch))
        navigationItem.leftBarButtonItem = userCountBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        ref.queryOrdered(byChild: "addedByUser").queryEqual(toValue: UserDefaults.standard.object(forKey: "EMAIL")).observe(.value) { snapshot in
            var newItems: [NotesItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let notesItem = NotesItem(snapshot: snapshot) {
                    newItems.append(notesItem)
                }
            }
            
            self.items = newItems
            self.tableView.reloadData()
        }
        
        
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let notesItem = items[indexPath.row]
        
        cell.textLabel?.text = notesItem.notesStr
        cell.detailTextLabel?.text = notesItem.addedByUser
        
        toggleCellCheckbox(cell, isCompleted: notesItem.completed)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notesItem = items[indexPath.row]
            notesItem.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let notesItem = items[indexPath.row]
        let toggledCompletion = !notesItem.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        notesItem.ref?.updateChildValues([
            "completed": toggledCompletion
        ])
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.textColor = .black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .gray
        }
    }
    
    // MARK: Add Item
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Notes",
                                      message: "Add a note",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            let notesItem = NotesItem(notesStr: text, addedByUser: self.user.email,completed: false, addedTimestamp: Int(NSDate().timeIntervalSince1970))
            let notesItemRef = self.ref.child(text.lowercased())
            notesItemRef.setValue(notesItem.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func userCountButtonDidTouch() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        // performSegue(withIdentifier: listToUsers, sender: nil)
    }
}
