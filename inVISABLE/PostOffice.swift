//
//  PostOffice.swift
//  inVISABLE
//
//  Created by Angelica Bato on 1/26/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostOffice {
    static var manager = PostOffice()
    
    let ref = FirebaseManager.shared.reference
    var feedPosts = [Post]()
    var userPosts = [Post]()
    
    //TODO: Figure out sort with firebase, observe events?
    //TODO: Add 2 user to test multiple users in feed.
    
    func requestFeedPosts(for user: String) {
        
    }
    
    func requestUserPosts(for userID: String, completion: @escaping (_ success: Bool) -> Void) {
        if userPosts.count > 0 {
            userPosts.removeAll()
        }
        ref.child("user-posts").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [AnyHashable: Any], let allPosts = Array(dictionary.values) as? [[AnyHashable: Any]] {
                for post in allPosts {
                    guard let dateString = post["date"] as? NSString, let text = post["text"] else { return }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = formatter.date(from: dateString as String)
                    let post = Post(date: date!, post: text as! NSString, image: nil, name: INUser.shared.name)
                    self.userPosts.append(post)
                }
                completion(true)
            }
            completion(false)
        }
    }
    
    
    
}
