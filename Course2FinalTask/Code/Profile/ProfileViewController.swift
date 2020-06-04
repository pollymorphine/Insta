//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Polina on 18.02.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

final class  ProfileViewController: UICollectionViewController {
    
    var currentUser: User?
    private var posts: [Post]?
    private let reuseIdentifier = "profileCell"
    private let reuseHeaderIdentifier = "ProfileReusableView"
    
    //    override func awakeFromNib() {
    //           super.awakeFromNib()
    //        guard let view = self.tabBarController?.view else { return }
    //               spinner = Spinner(view: view)
    //               spinner?.startAnimating()
    //    }
    
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let user = currentUser {
            self.navigationItem.title = user.username
        } else {
            let currentUserGroup = DispatchGroup()
            currentUserGroup.enter()
            
            userProvider.currentUser(queue: queue) { user in
                self.currentUser = user
                
                DispatchQueue.main.async {
                    self.navigationItem.title = self.currentUser?.username
                    // spinner?.stopAnimating()
                }
                currentUserGroup.leave()
            }
            currentUserGroup.wait()
        }
        
        let findPostsGroup = DispatchGroup()
        findPostsGroup.enter()
        
        guard let id = currentUser?.id else { return }
        
        postProvider.findPosts(by: id, queue: queue) { posts in
            guard let posts = posts else {
                alert.showError()
                return
            }
            
            let sortedPosts = posts.sorted(by: { $0.createdTime > $1.createdTime })
            self.posts = sortedPosts
            findPostsGroup.leave()
        }
        findPostsGroup.wait()
    }
}

// MARK: UICollectionViewDataSource

extension ProfileViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let posts = posts else { return [Post]().count }
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProfileCell
            else { return UICollectionViewCell() }
        
        let currentPost = posts?[indexPath.row]
        cell.profileImage.image = currentPost?.image
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let kind = UICollectionView.elementKindSectionHeader
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as? ProfileReusableView
            else { return UICollectionReusableView() }
        
        guard let user = currentUser else { return UICollectionReusableView() }
        headerView.configure(user: user)
        headerView.delegate = self
        
        return headerView
    }
    
    // MARK: Functions
    
    func showFollowers() {
        spinner?.startAnimating()
        
        guard let id = currentUser?.id else { return }
        guard let follow = storyboard?.instantiateViewController(withIdentifier: "followViewController") as? FollowViewController else { return }
        userProvider.usersFollowingUser(with: id, queue: queue) { followingUsers in
            guard followingUsers != nil else {
                alert.showError()
                return
            }
            follow.users = followingUsers
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(follow, animated: true)
                follow.navigationItemTitle = "Followers"
                spinner?.stopAnimating()
            }
        }
    }
    
    func showFollowing() {
        spinner?.startAnimating()
        
        guard let id = currentUser?.id else { return }
        guard let follow = storyboard?.instantiateViewController(withIdentifier:
            "followViewController") as? FollowViewController else { return }
        
        userProvider.usersFollowedByUser(with: id, queue: queue) { followedUsers in
            guard followedUsers != nil else {
                alert.showError()
                return
            }
            follow.users = followedUsers
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(follow, animated: true)
                follow.navigationItemTitle = "Followed"
                spinner?.stopAnimating()
            }
        }
    }
    
    func followUser(header: ProfileReusableView) {
        guard let id = currentUser?.id else { return }
        guard let text = header.followButton.titleLabel?.text else { return }
        
        if text == "Follow" {
            userProvider.follow(id, queue: queue) { _ in }
            header.followButton.setTitle("Unfollow", for: .normal)
            header.followersLabel.text = "Followers: \(currentUser!.followedByCount + 0)"
        } else {
            userProvider.unfollow(id, queue: queue) { _ in }
            header.followButton.setTitle("Follow", for: .normal)
            header.followersLabel.text = "Followers: \(currentUser!.followedByCount - 1)"
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width / 3,
            height: collectionView.bounds.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
