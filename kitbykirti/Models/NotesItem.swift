//
//  NotesItem.swift
//  kitbykirti
//
//  Created by Appy on 10/02/20.
//  Copyright © 2020 Appy. All rights reserved.
//

import Foundation
import Firebase

struct NotesItem {
    
    let ref: DatabaseReference?
    let key: String
    let notesStr: String
    let addedByUser: String
    var completed: Bool
    let addedTimestamp: Int
    
    init(notesStr: String, addedByUser: String, completed: Bool, key: String = "", addedTimestamp: Int) {
        self.ref = nil
        self.key = key
        self.notesStr = notesStr
        self.addedByUser = addedByUser
        self.completed = completed
        self.addedTimestamp = addedTimestamp
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let notesStr = value["notesStr"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let completed = value["completed"] as? Bool,
            let addedTimestamp = value["addedTimestamp"] as? Int else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.notesStr = notesStr
        self.addedByUser = addedByUser
        self.completed = completed
        self.addedTimestamp = addedTimestamp
    }
    
    func toAnyObject() -> Any {
        return [
            "notesStr": notesStr,
            "addedByUser": addedByUser,
            "completed": completed,
            "addedTimestamp": addedTimestamp
        ]
    }
}
