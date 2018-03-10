//
//  User.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 2/18/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseAuth

struct INUser {
    static var shared = INUser()
    
    var user : User? {
        get {
            return mutableUser
        }
    }
    
    var posts: NSArray {
        return mutablePosts
    }
    
    var image: UIImage?
    var bio: NSString
    var numFollowers: Int
    var numFollowing: Int
    var followers: NSArray
    var following: NSArray
    var illnesses: NSArray
    var interests: NSArray
    var location: NSString
    var name: NSString
    
    private var mutableUser : User?
    private var mutablePosts: NSMutableArray
    
    public init() {
        mutableUser = nil
        image = nil
        bio = ""
        numFollowers = 0
        numFollowing = 0
        followers = []
        following = []
        mutablePosts = []
        illnesses = []
        interests = []
        location = ""
        name = ""
    }
    
    mutating func updateFIRUser(with user: User) {
        self.mutableUser = user
    }
    
    mutating func add(_ post: NSString) {
        objc_sync_enter(self)
        mutablePosts.add(post)
        objc_sync_exit(self)
        FirebaseManager.shared.add(post)
    }
    
    mutating func update(with dictionary: NSDictionary) {
        self.bio = dictionary[bioKey] as? NSString ?? ""
        let postsDictionary = dictionary[postsKey] as? NSDictionary ?? [:]
        self.mutablePosts = NSMutableArray(array: postsDictionary.allValues as NSArray)
        self.followers = dictionary[followersKey] as? NSArray ?? []
        self.following = dictionary[followingKey] as? NSArray ?? []
        self.numFollowers = self.followers.count
        self.numFollowing = self.following.count
        self.illnesses = dictionary[illnessesKey] as? NSArray ?? []
        self.interests = dictionary[interestsKey] as? NSArray ?? []
        self.location = dictionary[locationKey] as? NSString ?? ""
        self.name = dictionary[nameKey] as? NSString ?? ""
    }
    
    func createUserInfoDictionary() -> [NSString : Any] {
        return [
         bioKey: bio,
         followersKey: followers,
         followingKey: following,
         postsKey: posts,
         illnessesKey: illnesses,
         interestsKey: interests,
         locationKey: location,
         nameKey: name
         ]
    }
}




//class methods
//instance methods
//static function
