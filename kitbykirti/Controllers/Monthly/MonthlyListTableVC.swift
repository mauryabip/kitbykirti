//
//  MonthlyListTableVC.swift
//  kitbykirti
//
//  Created by UMENIT on 20/03/20.
//  Copyright © 2020 Appy. All rights reserved.
//

import UIKit
import Firebase

class MonthlyListTableVC: UITableViewController {
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    // MARK: Properties
    var items: [MontlyItem] = []
    var user: User!
    let ref = Database.database().reference(withPath: "MonthlyList")
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        let userCountBarButtonItem: UIBarButtonItem! = UIBarButtonItem(image: UIImage.init(named: "backArrow"), style: .plain, target: self, action: #selector(userCountButtonDidTouch))
        navigationItem.leftBarButtonItem = userCountBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        ref.queryOrdered(byChild: "addedByUser").queryEqual(toValue: UserDefaults.standard.object(forKey: "EMAIL")).observe(.value) { snapshot in
            var newItems: [MontlyItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let notesItem = MontlyItem(snapshot: snapshot) {
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
        cell.detailTextLabel?.text = "\(notesItem.addedByUser)\n\n\(notesItem.notesMonth)"
        
        toggleCellCheckbox(cell, isCompleted: true)
        
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
        //let notesItem = items[indexPath.row]
        toggleCellCheckbox(cell, isCompleted: true)
//        notesItem.ref?.updateChildValues([
//            "completed": toggledCompletion
//        ])
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = .none
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black
    }
    
    
    
    @objc func userCountButtonDidTouch() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        // performSegue(withIdentifier: listToUsers, sender: nil)
    }
}
