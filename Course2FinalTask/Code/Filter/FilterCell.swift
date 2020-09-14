//
//  FilterCell.swift
//  Course2FinalTask
//
//  Created by Polina on 03.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class FilterCell: UICollectionViewCell {

    @IBOutlet var smallFilterImageView: UIImageView!
    @IBOutlet var filterName: UILabel!

    weak var delegate: FilterViewController?
}
