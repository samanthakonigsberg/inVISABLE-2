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
    var feedPosts = [FeedPost]()
    var userPosts = [UserPost]()
    
    func listenToFeedPosts(for userID: String, completion: @escaping (_ newPost: FeedPost) -> Void) {
        ref.child("feed-posts").child(userID).observe(.childAdded) { (snapshot) in
            guard let post = snapshot.value as? [AnyHashable: Any], let dateString = post["date"] as? NSString, let text = post["text"] as? NSString, let name = post["name"] as? NSString, let id = post["user"] as? NSString else { return }
            
            let postId = snapshot.key
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: dateString as String)
            let newPost = FeedPost(postId: postId as NSString, date: date!, post: text, name: name, userId: id)
            self.feedPosts.insert(newPost, at: 0)
            completion(newPost)
        }
    }
    
    func requestFeedPosts(for userID: String, completion: @escaping (_ success: Bool) -> Void) {
        if feedPosts.count > 0 {
            feedPosts.removeAll()
        }
        ref.child("feed-posts").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [AnyHashable: Any] {
                for postId in dictionary.keys {
                    guard let post = dictionary[postId] as? [AnyHashable: Any], let dateString = post["date"] as? NSString, let text = post["text"] as? NSString, let name = post["name"] as? NSString, let id = post["user"] as? NSString else { return }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = formatter.date(from: dateString as String)
                    let feedPost = FeedPost(postId: postId as! NSString, date: date!, post: text, name: name, userId: id)
                    self.feedPosts.append(feedPost)
                }
                
                self.feedPosts = self.feedPosts.sorted(by: { $0.date > $1.date })
                completion(true)
            }
            completion(false)
        }
    }
    
    func requestUserPosts(for userID: String, completion: @escaping (_ success: Bool) -> Void) {
        if userPosts.count > 0 {
            userPosts.removeAll()
        }
        ref.child("user-posts").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [AnyHashable: Any], let allUserPosts = Array(dictionary.values) as? [[AnyHashable: Any]] {
                for post in allUserPosts {
                    guard let dateString = post["date"] as? NSString, let text = post["text"] as? NSString, let name = post["name"] as? NSString else { return }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = formatter.date(from: dateString as String)
                    let post = UserPost(date: date!, post: text, name: name)
                    self.userPosts.append(post)
                }
                
                self.userPosts = self.userPosts.sorted(by: { $0.date > $1.date })
                completion(true)
            }
            completion(false)
        }
    }
    
    
    
}
