//
//  FirebaseManager.swift
//  inVISABLE
//
//  Created by Angelica Bato on 1/12/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

enum UpdateType {
    case email
    case name
    case bio
    case posts
    case following
}

class FirebaseManager {
    static let shared = FirebaseManager()
    var reference: DatabaseReference = Database.database().reference()
    
    func createUser(email: String, password: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) -> Void {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let confirmedUser = user else {
                completion(false, error)
                return
            }
            INUser.shared.updateFIRUser(with: confirmedUser)
            completion(true, error)
        }
    }
    
    func login(email: String, password: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void ) -> Void {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let confirmedUser = user else {
                completion(false, error)
                return
            }
            
            INUser.shared.updateFIRUser(with: confirmedUser)
            
            self.reference.child("users").child(confirmedUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let value = snapshot.value as? NSDictionary else {
                    completion(false, nil)
                    return
                }
                INUser.shared.update(with: value)
                completion(true, nil)
            })
        }
    }
    
    //TODO: untested!
    func updateAllUserInfo() {
        guard let user = INUser.shared.user else { return }
        reference.child("users").child(user.uid).updateChildValues(INUser.shared.createUserInfoDictionary())
    }
    
    func add(_ post: NSString) {
        guard let user = INUser.shared.user else { return }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let key = reference.child("user-posts").child(user.uid).childByAutoId().key
        let postDict = ["date": formatter.string(from: date) as NSString,
                        "text": post] as [String: Any]
        reference.child("user-posts").child(user.uid).child(key).updateChildValues(postDict)
    }
    
    
    
    //TODO: Update firebase architecture to work with friend lists and feed
    //TODO: Create function to populate feed and friend list; should not be attached to INUser.
}
