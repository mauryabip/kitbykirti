//
//  AddDaywiseVC.swift
//  kitbykirti
//
//  Created by UMENIT on 20/03/20.
//  Copyright © 2020 Appy. All rights reserved.
//

import UIKit
import Firebase

class AddDaywiseVC: BaseViewController {

    let ref = Database.database().reference(withPath: "DayList")
    
    @IBOutlet weak var monthNoteImageView: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let dayName = UserDefaults.standard.object(forKey: "DAYNAME") as! String
        let first3 = String(dayName.prefix(3))
        let monthImgName = "\(UserDefaults.standard.object(forKey: "MONTHNAME") ?? "")\(first3)"
        self.monthNoteImageView.image = UIImage.init(named: monthImgName)
    }
    
    @IBAction func addNotesBtnAction(_ sender: UIButton) {
        guard let text = txtView.text else {  self.navigationController?.view.makeToast("Please write something to add notes.", duration: 2.0, position: .bottom, title: "Warning!", image: nil)
            return
        }
        
        let notesItem = DayItem(notesStr: text, addedByUser: (Auth.auth().currentUser?.email)!, notesDay: UserDefaults.standard.object(forKey: "DAYNAME") as! String, addedTimestamp: Int(NSDate().timeIntervalSince1970))
        let notesItemRef = self.ref.child("Daywise")
        notesItemRef.setValue(notesItem.toAnyObject())
        self.navigationController?.popViewController(animated: true)
    }

}
