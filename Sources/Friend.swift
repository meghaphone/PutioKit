//
//  Friend.swift
//  PutioKit
//
//  Created by Stephen Radford on 10/01/2017.
//
//

import Foundation

public final class Friend: NSObject {
    
    /// The username of the friend
    public dynamic var username = ""
    
    /// URL of the user's avatar
    public dynamic var avatar = ""
    
    /// The ID that can be used for unsharing a file
    public dynamic var shareId = 0
    
    internal convenience init(json: [String:Any]) {
        self.init()
        username = json["user_name"] as? String ?? ""
        avatar = json ["user_avatar_url"] as? String ?? ""
        shareId = json["share_id"] as? Int ?? 0
    }
    
}
