//
//  WeekListVC.swift
//  kitbykirti
//
//  Created by UMENIT on 21/03/20.
//  Copyright © 2020 Appy. All rights reserved.
//

import UIKit

class WeekListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITableView Delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekCell", for: indexPath)
        let label = cell.viewWithTag(100) as! UILabel
        label.text = indexPath.row == 0 ? "1st Week" : indexPath.row == 1 ? "2nd Week" :indexPath.row == 2 ? "3rd Week" : indexPath.row == 3 ? "4th Week" : "5th Week"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
