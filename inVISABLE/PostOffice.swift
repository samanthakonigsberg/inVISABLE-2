//
//  PostOffice.swift
//  inVISABLE
//
//  Created by Angelica Bato on 1/26/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct PostOffice {
    static let manager = PostOffice()
    
    let ref = DatabaseReference()
    var feedPosts = [String]()
    var userPosts = [String]()
    
    func requestUserPosts(for user: String) {
        
    }
    
    func requestFeedPosts(for user: String) {
        ref.child("user-posts").child(user).queryOrdered(byChild: "data")
    }
    
    
    
}
