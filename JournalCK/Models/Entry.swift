//
//  Entry.swift
//  JournalCK
//
//  Created by Jon Corn on 2/4/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import Foundation
import CloudKit

// MARK: - String helpers
struct EntryStrings {
    static let recordTypeKey = "Entry"
    fileprivate static let titleKey = "title"
    fileprivate static let bodyTextKey = "bodyText"
    fileprivate static let timestampKey = "timestamp"
}

// MARK: - Entry Model
class Entry {
    var title: String
    var bodyText: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, bodyText: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}

// MARK: - Fetch record
extension Entry {
    // fetch record
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryStrings.titleKey] as? String,
            let bodyText = ckRecord[EntryStrings.bodyTextKey] as? String,
            let timestamp = ckRecord[EntryStrings.timestampKey] as? Date
            else {return nil}
        
        self.init(title: title, bodyText: bodyText, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}
// MARK: - Create record
extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryStrings.recordTypeKey)
        self.setValuesForKeys([
            EntryStrings.titleKey : entry.title,
            EntryStrings.bodyTextKey : entry.bodyText,
            EntryStrings.timestampKey : entry.timestamp
        ])
    }
}


