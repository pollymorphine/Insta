//
//  FeedCell.swift
//  Course2FinalTask
//
//  Created by Polina on 20.02.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

final class FeedCell: UITableViewCell {

    @IBOutlet var likeButton: UIButton!
    @IBOutlet private var userAvatar: UIImageView!
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var postDate: UILabel!
    @IBOutlet private var postImage: UIImageView!
    @IBOutlet private var bigLikeImage: UIImageView!
    @IBOutlet private var likesCount: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var stackView: UIStackView!

    weak var delegate: FeedViewController?

    override func awakeFromNib() {
        super.awakeFromNib()

        registerTapGestureRecognizers()
        stackView.addGestureRecognizer(addTapGestureRecognizerForUser())

        bigLikeImage.alpha = 0.0
    }

    func configure(with post: Post) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let dateString = dateFormatter.date(from: post.createdTime) else { return }
        let date = dateFormatter.string(from: dateString)
        
        userAvatar.kf.setImage(with: URL(string: post.authorAvatar))
        postDate.text = date
        userName.text = post.authorUsername
        postImage.kf.setImage(with: URL(string: post.image))
        likesCount.text = "Likes: \(post.likedByCount)"
        descriptionLabel.text  = post.description

        if post.currentUserLikesThisPost {
            likeButton.tintColor = .blue
        } else {
            likeButton.tintColor = .lightGray
        }
    }

    @IBAction func tapLikeButton(_ sender: UIButton) {
       delegate?.tapLikePostButton(cell: self)
    }

    @objc func tapToWatchProfile() {
        spinner?.startAnimating()
        delegate?.showProfile(cell: self)
    }

    @objc func showBigLikeAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: {
            self.bigLikeImage.alpha = 1.0
        }, completion: {_ in
            UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
                self.bigLikeImage.alpha = 0
            }, completion: nil)
        })

        if likeButton.tintColor == UIColor.lightGray {
            delegate?.tapLikePostButton(cell: self)
        }
    }

    @objc func tapToWatchWhoLiked() {
        spinner?.startAnimating()
        delegate?.showWhoLiked(cell: self)
    }

    private func registerTapGestureRecognizers() {
        let tapLikesCountLable = UITapGestureRecognizer(target: self, action: #selector(tapToWatchWhoLiked))
        likesCount.addGestureRecognizer(tapLikesCountLable)

        let tapBigLike = UITapGestureRecognizer(target: self, action: #selector(showBigLikeAnimation))
        tapBigLike.numberOfTapsRequired = 2
        postImage.addGestureRecognizer(tapBigLike)
    }

    private func addTapGestureRecognizerForUser() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToWatchProfile))

        return tapGestureRecognizer
    }
}
