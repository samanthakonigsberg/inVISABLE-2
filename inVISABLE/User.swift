//
//  User.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 2/18/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit
import FirebaseAuth

//static let = singleton
struct CurrentUser {
    static var shared = INUser(user: nil, image: nil, bio: "", followers: NSNumber(integerLiteral: 0), following: NSNumber(integerLiteral: 0), posts: [], illnesses: [], interests: [], location: "", name: "")
}

struct INUser {
    
    let user : User?
    
    //send bottom five to firebase as additional properties
    var image: UIImage?
    var bio: NSString
    var followers: NSNumber
    var following: NSNumber
    var posts: NSArray
    var illnesses: NSArray
    var interests: NSArray
    var location: NSString
    var name: NSString
    
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
