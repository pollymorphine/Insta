//
//  Data Provider.swift
//  Course2FinalTask
//
//  Created by Polina on 25.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import DataProvider

public let postProvider = DataProviders.shared.postsDataProvider
public let userProvider = DataProviders.shared.usersDataProvider
public let photoProvider = DataProviders.shared.photoProvider
public let queue = DispatchQueue.global(qos: .userInitiated)
