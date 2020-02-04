//
//  EntryController.swift
//  JournalCK
//
//  Created by Jon Corn on 2/4/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    // MARK: - Properties
    let privateDB = CKContainer.default().privateCloudDatabase
    static let shared = EntryController()
    var entries = [Entry]()
    
    // MARK: - CRUD Functions
    func save(entry: Entry, completion: @escaping (Bool) -> ()) {
        let record = CKRecord(entry: entry)
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("Error saving entry:", error.localizedDescription)
                return completion(false)
            }
            guard let record = record,
                let entry = Entry(ckRecord: record) else {return completion(false)}
            self.entries.append(entry)
            completion(true)
        }
    }
    
    func addEntryWith(title: String, bodyText: String, completion: @escaping (Bool) -> Void) {
        let entry = Entry(title: title, bodyText: bodyText)
        save(entry: entry, completion: completion)
    }
    
    func fetchEntries(completion: @escaping (Bool) -> Void) {
        let queryAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryStrings.recordTypeKey, predicate: queryAllPredicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching entries:", error.localizedDescription)
                return completion(false)
            }
            guard let records = records else {return completion(false)}
            let entries = records.compactMap({ entry in
                Entry(ckRecord: entry)
            })
            self.entries = entries
            return completion(true)
        }
    }
}
