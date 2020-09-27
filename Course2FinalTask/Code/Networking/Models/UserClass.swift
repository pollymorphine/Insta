//
//  UserClass.swift
//  Course2FinalTask
//
//  Created by Polina on 26.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

class UserClass {
    
    let id: String
    let username: String
    let fullName: String
    let avatar: URL
    let currentUserFollowsThisUser: Bool
    let currentUserIsFollowedByThisUser: Bool
    let followsCount: Int
    let followedByCount: Int
    
    init?(user: UserEntity) {
        guard let id = user.id,
              let username = user.username,
              let fullName = user.fullName,
              let avatar = user.avatar else
        { return nil }
        
        self.id = id
        self.username = username
        self.fullName = fullName
        self.avatar = avatar
        self.currentUserFollowsThisUser = user.currentUserFollowsThisUser
        self.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
        self.followsCount = Int(user.followsCount)
        self.followedByCount = Int(user.followedByCount)
    }
    
    init(user: User){
        self.id = user.id
        self.username = user.username
        self.fullName = user.fullName
        self.avatar = user.avatar
        self.currentUserFollowsThisUser = user.currentUserFollowsThisUser
        self.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
        self.followsCount = user.followsCount
        self.followedByCount = user.followedByCount
    }
}
