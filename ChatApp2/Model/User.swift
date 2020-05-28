//
//  User.swift
//  ChatApp2
//
//  Created by David Saley on 5/10/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String 
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
    
    
    
}
