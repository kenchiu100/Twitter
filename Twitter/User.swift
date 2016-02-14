//
//  User.swift
//  Twitter
//
//  Created by KaKin Chiu on 2/12/16.
//  Copyright © 2016 KaKinChiu. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["nane"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User?{
        get{
            if _currentUser == nil{
            let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil{
        
                    let dictionary: NSDictionary?
                        do {
                            try dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                            _currentUser = User(dictionary: dictionary!)
                            } catch {
                    print(error)
                    }
                    }
                    }

            return _currentUser
        }
        
        set(user){
            _currentUser = user
            
            if _currentUser != nil{
                if _currentUser != nil {
                    do {
                        
                        // What does this mean?:
                        let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions());
                        NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey);
                    } catch _ {
                        
                    }
                }else{
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey);
            }
            NSUserDefaults.standardUserDefaults().synchronize();
        }
    }
    }}