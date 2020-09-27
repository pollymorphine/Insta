//
//  ProfileReusableView.swift
//  Course2FinalTask
//
//  Created by Polina on 23.02.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

final class ProfileReusableView: UICollectionReusableView {

    @IBOutlet  var profileAvatar: UIImageView!
    @IBOutlet  var userName: UILabel!
    @IBOutlet var followersLabel: UILabel!
    @IBOutlet  var followingLabel: UILabel!
    @IBOutlet var followButton: UIButton!

    weak var delegate: ProfileViewController?

    override func awakeFromNib() {
        super.awakeFromNib()

        profileAvatar.layer.cornerRadius = profileAvatar.frame.width / 2
        profileAvatar.clipsToBounds = true

        followButton.layer.cornerRadius = followButton.frame.width / 15
        followButton.clipsToBounds = true
        followButton.isHidden = false

        addTapsGestureRecognizer()
    }

    func configure(user: UserClass) {
        profileAvatar.kf.setImage(with: user.avatar)
        userName.text = user.fullName
        followersLabel.text = "Followers: \(user.followedByCount)"
        followingLabel.text = "Following: \(user.followsCount)"
        
        if user.username == "ivan1975" {
            followButton.isHidden = true
        }
}

    @objc func tapToWatchFollowers() {
        spinner?.startAnimating()
        delegate?.showFollowers()
    }

    @objc func tapToWatchFollowing() {
        spinner?.startAnimating()
        delegate?.showFollowing()
    }

    @objc func tapToFollow() {
        delegate?.followUser(header: self)
    }

    func addTapsGestureRecognizer() {
        let tapFollowersLabel = UITapGestureRecognizer(target: self, action: #selector(tapToWatchFollowers))
        followersLabel.addGestureRecognizer(tapFollowersLabel)

        let tapFollowingLabel = UITapGestureRecognizer(target: self, action: #selector(tapToWatchFollowing))
        followingLabel.addGestureRecognizer(tapFollowingLabel)

        let tapFollowButton = UITapGestureRecognizer(target: self, action: #selector(tapToFollow))
        followButton.addGestureRecognizer(tapFollowButton)
    }
    
    
}
