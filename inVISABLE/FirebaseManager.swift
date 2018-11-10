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
            self.reference.child("user-posts").child(userId).observe(.value, with: { (snapshot) in
                guard let posts = snapshot.value as? NSDictionary else {
                    return
                }
                for k in posts.allKeys {
                    guard var postInfo = posts[k] as? NSMutableDictionary else { continue }
                    postInfo["user"] = userId
                    self.reference.child("feed-posts").child(currentUser.uid).child(k as! String).updateChildValues(postInfo as! [AnyHashable: AnyObject])
                }
                
            })
        }
    }
    
    func removeUserAsFollowerFor(userId: String) {
        guard let currentUser = INUser.shared.user else { return }
        reference.child("users").child(userId).child("followers").observeSingleEvent(of: .value) { (snapshot) in
            if let arr = snapshot.value as? NSArray {
                if arr.contains(currentUser.uid) {
                    let index = arr.index(of: currentUser.uid)
                    let mutableArr = NSMutableArray(array: arr)
                    mutableArr.removeObject(at: index)
                    self.reference.child("users").child(userId).updateChildValues(["followers": mutableArr as NSArray])
                }
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
        reference.child("users").queryStarting(atValue: name).queryEnding(atValue: name + "\u{f8ff}").queryOrdered(byChild: "name").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? NSDictionary, value.allKeys.count > 0 else {
                completion(false, nil, nil)
                return
            }
            
            var results: [INUser] = []
            for key in value.allKeys {
                guard let userInfo = value[key] as? NSDictionary, let k = key as? String, !INUser.shared.blocked.contains(k) else { continue }
                var user = INUser()
                user.update(with: userInfo)
                user.id = k
                results.append(user)
            }
            
            completion(true, nil, results)
        }
    }
    
    func reportUser(_ reportedUser: String, reporter: String, reason: String) {
        let report = ["reportFor": reportedUser as NSString,
                      "reportedBy": reporter as NSString,
                      "reason": reason as NSString]
        reference.child("reports").child("users").childByAutoId().updateChildValues(report)
    }
    
    func reportPost(_ reporter: String, post: FeedPost, reason: String) {
        let report = ["postId": post.postId,
                      "reportedPost": post.post,
                      "reportedUser": post.userId,
                      "reportedBy": reporter as NSString,
                      "reason": reason as NSString]
        reference.child("reports").child("posts").childByAutoId().updateChildValues(report)
    }
    
    func block(_ user: String) {
        guard let currentId = INUser.shared.user?.uid, let mutableFollowing = INUser.shared.following as? NSMutableArray else { return }
        
        //Update current user's blocked and following
        INUser.shared.blocked = INUser.shared.blocked.adding(user) as NSArray
        if mutableFollowing.contains(user) {
            mutableFollowing.remove(user)
        }
        INUser.shared.following = mutableFollowing as NSArray
        reference.child("users").child(currentId).updateChildValues([blockedKey: INUser.shared.blocked, followingKey: INUser.shared.following])
        removeUserAsFollowerFor(userId: user)
        
        reference.child("users").child(user).child("blocked").observeSingleEvent(of: .value) { (snapshot) in
            let newArr = NSMutableArray(array: [currentId])
            if let arr = snapshot.value as? [Any] {
                newArr.addObjects(from: arr)
            }
            self.reference.child("users").child(user).updateChildValues(["blocked": newArr])
        }
        
        PostOffice.manager.feedPosts = PostOffice.manager.feedPosts.filter( { $0.userId as String != user } )
        PostOffice.manager.update(PostOffice.manager.feedPosts, for: currentId)
        PostOffice.manager.requestFeedPosts(for: user) { (success, posts) in
            guard var p = posts else { return }
            p = p.filter({ $0.userId as String != currentId })
            PostOffice.manager.update(p, for: user)
        }
    }
    
    func store(_ image: UIImage) {
        guard let imageData: Data = UIImagePNGRepresentation(image) else { return }
        
        if INUser.shared.imageRef.length > 0 {
            let oldRef = storage.reference().child(INUser.shared.imageRef as String)
            oldRef.delete { (error) in
                if let e = error {
                    print("Error deleting image. Error: \(e)")
                }
                self.uploadImageData(imageData)
            }
        } else {
            self.uploadImageData(imageData)
        }
        

    }
    
    func uploadImageData(_ data: Data) {
        guard let user = INUser.shared.user else { return }
        let urlString = "/users/\(user.uid)/\(UUID().uuidString).img"
        INUser.shared.imageRef = urlString as NSString
        let newRef = self.storage.reference().child(urlString)
        
        let _ = newRef.putData(data, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                print("Error storing images. There is no metadata.")
                // uh oh error
                return
            }
            
            newRef.downloadURL(completion: { (url, error) in
                guard let downloadUrl = url else {
                    print("Error storing images. There is no download url")
                    //uh oh error
                    return
                }
                
                //You should only be able to store your own image.
                INUser.shared.imageUrl = downloadUrl.absoluteString as NSString
                FirebaseManager.shared.updateAllUserInfo()
            })
        }
    }
}
