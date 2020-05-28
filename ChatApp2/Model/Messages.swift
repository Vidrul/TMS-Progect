//
//  Messages.swift
//  ChatApp2
//
//  Created by David Saley on 5/17/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Message: NSObject {

    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
    
    func chatPartherId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
}
