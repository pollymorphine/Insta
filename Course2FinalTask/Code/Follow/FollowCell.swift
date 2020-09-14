//
//  FollowCell.swift
//  Course2FinalTask
//
//  Created by Polina on 25.02.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class FollowCell: UITableViewCell {

    weak var delegate: FollowViewController?

    @IBOutlet var userAvatar: UIImageView!
    @IBOutlet var userName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        addTapGestureRecognizer()
    }

    @objc func tapToShowProfile() {
        spinner?.startAnimating()
        delegate?.showProfile(cell: self)
    }

    func addTapGestureRecognizer() {
        let tapUserAvatar = UITapGestureRecognizer(target: self, action: #selector(tapToShowProfile))
        userAvatar.addGestureRecognizer(tapUserAvatar)

        let tapUserName = UITapGestureRecognizer(target: self, action: #selector(tapToShowProfile))
        userName.addGestureRecognizer(tapUserName)
    }
}
