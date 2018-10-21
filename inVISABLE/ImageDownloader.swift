//
//  ImageDownloader.swift
//  inVISABLE
//
//  Created by Angelica Bato on 10/7/18.
//  Copyright © 2018 Samantha Konigsberg. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

class ImageDownloader {
    var queue: [String]
    var cache: NSCache<AnyObject, AnyObject>
    var manifest: [String: NSString]
    let storage: Storage = Storage.storage()
    let database: Database = Database.database()
    
    static var downloader = ImageDownloader()
    
    init() {
        queue = [String]()
        cache = NSCache()
        manifest = [String: NSString]()
    }
    
    func hydrateCache() {
        guard let followers = INUser.shared.followers as? [String], let following = INUser.shared.following as? [String], let currentUser = INUser.shared.user else { return }
        
        queue = Array(Set(followers + following + [currentUser.uid]))
        
        for person in queue {
            database.reference().child("/users/\(person)/imagePath").observeSingleEvent(of: .value) { (snapshot) in
                guard let value = snapshot.value as? NSString, value.length > 0, self.cache.object(forKey: value as AnyObject) == nil else {
                    return
                }
                self.manifest[person] = value
                self.storage.reference().child(value as String).getData(maxSize: 8 * 2560 * 2560, completion: { (data, error) in
                    if let e = error {
                        print(e)
                    }
                    if let d = data {
                        self.cache.setObject(d as AnyObject, forKey: value as AnyObject)
                    }
                })
            }
        }
    }
    
    func getImageData(for person: String, completion: @escaping (_ imageData: Data?) -> Void) {
        database.reference().child("/users/\(person)/imagePath").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? NSString, value.length > 0 else { return }
            self.storage.reference().child(value as String).getData(maxSize: 8 * 2560 * 2560, completion: { (data, error) in
                if let d = data {
                    completion(d)
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    func getCachedImageData(for user: String) -> Data? {
        guard let path = manifest[user] else { return nil }
        return cache.object(forKey: path) as? Data
    }
    
    
}
