//
//  DayItem.swift
//  kitbykirti
//
//  Created by UMENIT on 20/03/20.
//  Copyright © 2020 Appy. All rights reserved.
//

import Foundation
import Firebase

struct DayItem {
    
    let ref: DatabaseReference?
    let key: String
    let notesStr: String
    let notesDay: String
    let addedByUser: String
    let addedTimestamp: Int
    
    init(notesStr: String, addedByUser: String, notesDay: String, key: String = "", addedTimestamp: Int) {
        self.ref = nil
        self.key = key
        self.notesStr = notesStr
        self.addedByUser = addedByUser
        self.notesDay = notesDay
        self.addedTimestamp = addedTimestamp
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let notesStr = value["notesStr"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let notesDay = value["notesDay"] as? String,
            let addedTimestamp = value["addedTimestamp"] as? Int else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.notesStr = notesStr
        self.addedByUser = addedByUser
        self.notesDay = notesDay
        self.addedTimestamp = addedTimestamp
    }
    
    func toAnyObject() -> Any {
        return [
            "notesStr": notesStr,
            "addedByUser": addedByUser,
            "notesDay": notesDay,
            "addedTimestamp": addedTimestamp
        ]
    }
}
