//
//  Constants.swift
//  Course2FinalTask
//
//  Created by Polina on 14.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

enum Identifier {
    static let feedController = "switchToFeed"
    static let filterCell = "filterCell"
    static let newPostCell = "newPostCell"
    static let showFilltersMenu = "showFilltersMenu"
    static let unwindToFeedCollection = "unwindToFeedCollection"
    static let feedCell = "FeedCell"
    static let followCell = "followCell"
    static let profileCell = "profileCell"
    static let followViewController = "followViewController"
    static let profileCollectionController = "profileCollectionController"
    static let profileReusableView = "ProfileReusableView"
    static let unwindToAuthentication = "unwindToAuthentication"
}

enum Filters {
   static let name = ["CIColorInvert",
                               "CIPixellate",
                               "CISpotColor",
                               "CISepiaTone",
                               "CISpotLight",
                               "CIZoomBlur",
                               "CIPhotoEffectNoir"]
}
