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
    var imageRef: NSString
    var imageUrl: NSString
    var bio: NSString
    var numFollowers: Int
    var numFollowing: Int
    var followers: NSArray
    var following: NSArray
    var illnesses: NSArray
    var interests: NSArray
    var name: NSString
    
    private var mutableUser : User?
    private var mutablePosts: NSMutableArray
    
    public init() {
        mutableUser = nil
        image = nil
        imageRef = ""
        imageUrl = ""
        bio = ""
        numFollowers = 0
        numFollowing = 0
        followers = []
        following = []
        mutablePosts = []
        illnesses = []
        interests = []
        name = ""
    }
    
    mutating func updateFIRUser(with user: User) {
        self.mutableUser = user
    }
    
    mutating func resetFIRUser() {
        self.mutableUser = nil
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
        self.name = dictionary[nameKey] as? NSString ?? ""
        self.imageRef = dictionary[imageRefKey] as? NSString ?? ""
        self.imageUrl = dictionary[imageUrlKey] as? NSString ?? ""
    }
    
    func createUserInfoDictionary() -> [NSString : Any] {
        return [
         bioKey: bio,
         followersKey: followers,
         followingKey: following,
         postsKey: posts,
         illnessesKey: illnesses,
         interestsKey: interests,
         nameKey: name,
         imageRefKey: imageRef,
         imageUrlKey: imageUrl
         ]
    }
}




//class methods
//instance methods
//static function
