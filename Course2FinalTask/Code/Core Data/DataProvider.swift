//
//  DataProvider.swift
//  Course2FinalTask
//
//  Created by Polina on 16.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataProvider {
    
    static let shared = DataProvider()
    
    func createUserEntity(_ user: User) {
        let context = CoreDataManager.shared.getContext()
        
        let userEntity = CoreDataManager.shared.createObject(from: UserEntity.self)
        userEntity.avatar = user.avatar
        userEntity.currentUserFollowsThisUser = user.currentUserFollowsThisUser
        userEntity.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
        userEntity.followedByCount = Int16(user.followedByCount)
        userEntity.followsCount = Int16(user.followsCount)
        userEntity.fullName = user.fullName
        userEntity.id = user.id
        userEntity.username = user.username
        
        CoreDataManager.shared.save(context: context)
    }
    
     func createPostEntity(_ post: Post) {
        let context = CoreDataManager.shared.getContext()

        let postEntity = CoreDataManager.shared.createObject(from: PostEntity.self)
        postEntity.createdTime = post.createdTime
        postEntity.currentUserLikesThisPost = post.currentUserLikesThisPost
        postEntity.descript = post.description
        postEntity.id = post.id
        postEntity.image = post.image
        postEntity.likedByCount = Int16(post.likedByCount)
        postEntity.authorAvatar = post.authorAvatar
        postEntity.author = post.author
        postEntity.authorUsername = post.authorUsername
        
        CoreDataManager.shared.save(context: context)

    }
  
    }

