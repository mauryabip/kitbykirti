//
//  AddMonthlyVC.swift
//  kitbykirti
//
//  Created by UMENIT on 20/03/20.
//  Copyright © 2020 Appy. All rights reserved.
//

import UIKit
import Firebase

class AddMonthlyVC: BaseViewController {

    let ref = Database.database().reference(withPath: "MonthlyList")
    
    @IBOutlet weak var monthNoteImageView: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.object(forKey: "MONTHNAME")
        let monthImgName = "\(UserDefaults.standard.object(forKey: "MONTHNAME") ?? "")notes"
        self.monthNoteImageView.image = UIImage.init(named: monthImgName)
    }
    
    @IBAction func addNotesBtnAction(_ sender: UIButton) {
        guard let text = txtView.text else {  self.navigationController?.view.makeToast("Please write something to add notes.", duration: 2.0, position: .bottom, title: "Warning!", image: nil)
            return
        }
        
        let notesItem = MontlyItem(notesStr: text, addedByUser: (Auth.auth().currentUser?.email)!, notesMonth: UserDefaults.standard.object(forKey: "MONTHNAME") as! String, addedTimestamp: Int(NSDate().timeIntervalSince1970))
        let notesItemRef = self.ref.child("monthly")
        notesItemRef.setValue(notesItem.toAnyObject())
        self.navigationController?.popViewController(animated: true)
    }

}
