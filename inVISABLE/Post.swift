//
//  Post.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 4/15/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct UserPost {
    var date: Date
    var post: NSString
    var name: NSString
}

struct FeedPost {
    var date: Date
    var post: NSString
    var name: NSString
    var userId: NSString
}
