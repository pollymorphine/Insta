//
//  Post.swift
//  Course2FinalTask
//
//  Created by Polina on 27.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

struct Post: Codable {
    var id: String
    var author: String
    var description: String
    var image: URL
    var createdTime: String
    var currentUserLikesThisPost: Bool
    var likedByCount: Int
    var authorUsername: String
    var authorAvatar: URL
}
