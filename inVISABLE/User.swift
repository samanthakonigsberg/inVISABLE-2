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
    
    //send bottom five to firebase as additional properties
    var image: UIImage?
    var bio: NSString
    var followers: NSNumber
    var following: NSNumber
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
        followers = NSNumber(integerLiteral: 0)
        following = NSNumber(integerLiteral: 0)
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
        mutablePosts.add(post)
    }
    
    mutating func update(with dictionary: NSDictionary) {
        self.bio = dictionary[bioKey] as? NSString ?? ""
        self.mutablePosts = dictionary[postsKey] as? NSMutableArray ?? []
        self.followers = dictionary[followersKey] as? NSNumber ?? NSNumber(integerLiteral: 0)
        self.following = dictionary[followingKey] as? NSNumber ?? NSNumber(integerLiteral: 0)
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
