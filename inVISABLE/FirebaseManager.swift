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
import FirebaseStorage

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
    var storage: Storage = Storage.storage()
    
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
    
    func addUserAsFollowerFor(userId: String) {
        guard let currentUser = INUser.shared.user else { return }
        reference.child("users").child(userId).child("followers").observeSingleEvent(of: .value) { (snapshot) in
            var array: NSArray
            if let arr = snapshot.value as? NSArray {
                array = arr.adding(currentUser.uid) as NSArray
            } else {
                array = NSArray(array: [currentUser.uid])
            }
            self.reference.child("users").child(userId).updateChildValues(["followers": array])
        }
    }
    
    func removeUserAsFollowerFor(userId: String) {
        guard let currentUser = INUser.shared.user else { return }
        reference.child("users").child(userId).child("followers").observeSingleEvent(of: .value) { (snapshot) in
            if let arr = snapshot.value as? NSArray {
                let index = arr.index(of: currentUser.uid)
                let mutableArr = NSMutableArray(array: arr)
                mutableArr.removeObject(at: index)
                self.reference.child("users").child(userId).updateChildValues(["followers": mutableArr as NSArray])
            }
        }
    }
    
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
        var userPostDict = ["date": formatter.string(from: date) as NSString,
                        "text": post,
                        "name": INUser.shared.name] as [String: Any]
        reference.child("user-posts").child(user.uid).child(key).updateChildValues(userPostDict)
        
        userPostDict["user"] = user.uid
        for follower in INUser.shared.followers {
            guard let f = follower as? String else { continue }
            reference.child("feed-posts").child(f).child(key).updateChildValues(userPostDict)
        }
    }
    
    func findUser(with name: String, completion: @escaping (_ success: Bool, _ error: Error?, _ results: [INUser]?) -> Void) -> Void {
        reference.child("users").queryStarting(atValue: name).queryOrdered(byChild: "name").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? NSDictionary, value.allKeys.count > 0 else {
                completion(false, nil, nil)
                return
            }
            
            var results: [INUser] = []
            for key in value.allKeys {
                guard let userInfo = value[key] as? NSDictionary, let k = key as? String else { continue }
                var user = INUser()
                user.update(with: userInfo)
                user.id = k
                results.append(user)
            }
            
            completion(true, nil, results)
        }
    }
    
    func store(_ image: UIImage) {
        guard let user = INUser.shared.user, let imageData: Data = UIImagePNGRepresentation(image) else { return }
        
        var ref: StorageReference
        if INUser.shared.imageRef.length > 0 {
            ref = storage.reference().child(INUser.shared.imageRef as String)
        } else {
            //Use UUID to determine uniqueness of the images.
            let urlString = "/users/\(user.uid)/\(UUID().uuidString).img"
            INUser.shared.imageRef = urlString as NSString
            ref = storage.reference().child(urlString)
        }
        
        let _ = ref.putData(imageData, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                print("Error storing images. There is no metadata.")
                // uh oh error
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
                guard let downloadUrl = url else {
                    print("Error storing images. There is no download url")
                    //uh oh error
                    return
                }
                
                //You should only be able to store your own image.
                INUser.shared.imageUrl = downloadUrl.absoluteString as NSString
            })
        }
    }
}
