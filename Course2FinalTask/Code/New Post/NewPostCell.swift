//
//  NewPostCell.swift
//  Course2FinalTask
//
//  Created by Polina on 02.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import DataProvider

final class NewPostCell: UICollectionViewCell {

    @IBOutlet  var newPostImage: UIImageView!

    weak var delegate: NewPostController?
}
