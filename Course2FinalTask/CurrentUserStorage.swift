//
//  CurrentUserStorage.swift
//  Course2FinalTask
//
//  Created by Polina on 26.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

class CurrentUserStorage {

    static var shared = CurrentUserStorage()

    init() { }

    var currentUser: User?

    func updateCurrentUser() {
        userProvider.currentUser(queue: queue) { [weak self] currentUser in
            self?.currentUser = currentUser
        }
    }
}
