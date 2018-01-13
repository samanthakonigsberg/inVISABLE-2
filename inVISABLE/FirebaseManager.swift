//
//  FirebaseManager.swift
//  inVISABLE
//
//  Created by Angelica Bato on 1/12/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseManager {
    static func createUser(email: String, password: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) -> Void {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            completion(user, error)
        }
    }
}
