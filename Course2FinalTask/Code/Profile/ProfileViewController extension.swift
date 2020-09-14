//
//  ProfileViewController extenssion.swift
//  Course2FinalTask
//
//  Created by Polina on 14.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

extension ProfileViewController {
    
    // MARK: Functions
    
    @objc func logout() {
        NetworkProvider.shared.signOut()
        Keychain.shared.deleteToken()
        performSegue(withIdentifier: "unwindToAuthentication", sender: self)
        self.navigationController?.popToRootViewController(animated: true)
     }

     func setupLogout() {
         DispatchQueue.main.async {
              let logoutButton = UIBarButtonItem(title: "Log out",
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(self.logout))
              self.navigationItem.setRightBarButton(logoutButton, animated: true)
            }
          }
    
    func showFollowers() {
        guard let id = user?.id else { return }
        guard let follow = storyboard?.instantiateViewController(withIdentifier: "followViewController") as? FollowViewController else { return }
        
        NetworkProvider.shared.getFollowers(userID: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                follow.users = users
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(follow, animated: true)
                    follow.navigationItemTitle = "Followers"
                    spinner?.stopAnimating()
                }
            case .fail(let networkError):
                DispatchQueue.main.async {
                    Alert.shared.showError(self, message: networkError.error)
                }
            }
        }
    }
    
    func showFollowing() {
        guard let id = user?.id else { return }
        guard let follow = storyboard?.instantiateViewController(withIdentifier:
            "followViewController") as? FollowViewController else { return }
        
        NetworkProvider.shared.getFollowingUsers(userID: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                follow.users = users
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(follow, animated: true)
                    follow.navigationItemTitle = "Following"
                    spinner?.stopAnimating()
                }
            case .fail(let networkError):
                DispatchQueue.main.async {
                    Alert.shared.showError(self, message: networkError.error)
                }
            }
        }
    }
    
    func followUser(header: ProfileReusableView) {
        guard let id = user?.id else { return }
        guard let text = header.followButton.titleLabel?.text else { return }
        
        if text == "Follow" {
            NetworkProvider.shared.follow(userID: id) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    self.user = user
                case .fail(let networkError):
                    DispatchQueue.main.async {
                        Alert.shared.showError(self, message: networkError.error)
                    }
                }
                DispatchQueue.main.async {
                    header.followButton.setTitle("Unfollow", for: .normal)
                    header.followersLabel.text = "Followers: \(self.user!.followedByCount + 0)"
                }
            }
        } else {
            NetworkProvider.shared.follow(userID: id) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    self.user = user
                case .fail(let networkError):
                    DispatchQueue.main.async {
                        Alert.shared.showError(self, message: networkError.error)
                    }
                }
                DispatchQueue.main.async {
                    header.followButton.setTitle("Follow", for: .normal)
                    header.followersLabel.text = "Followers: \(self.user!.followedByCount - 1)"
                }
            }
        }
    }
    
    public func userLoading() {
        if let user = user {
            guard let id = self.user?.id else { return }
            
            NetworkProvider.shared.findUserPosts(userID: id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let posts):
                    self.posts = posts
                    let sortedPosts = self.posts?.sorted(by: { $0.createdTime > $1.createdTime })
                    self.posts = sortedPosts
                    DispatchQueue.main.async {
                        self.navigationItem.title = user.username
                        self.collectionView.reloadData()
                    }
                    case .fail(let networkError):
                    Alert.shared.showError(self, message: networkError.error)
                }
            }
        } else {
            
            self.navigationItem.title = user?.username
            
            NetworkProvider.shared.сurrentUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.user = user
                    guard let id = self.user?.id else { return }
                    
                    NetworkProvider.shared.findUserPosts(userID: id) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let posts):
                            self.posts = posts
                            let sortedPosts = self.posts?.sorted(by: { $0.createdTime > $1.createdTime })
                            self.posts = sortedPosts
                            DispatchQueue.main.async {
                                self.setupLogout() 
                                self.navigationItem.title = self.user?.username
                                self.collectionView.reloadData()
                            }
                        case .fail(let networkError):
                            Alert.shared.showError(self, message: networkError.error)
                        }
                    }
                case .fail(let networkError):
                    DispatchQueue.main.async {
                        Alert.shared.showError(self, message: networkError.error)
                    }
                }
            }
        }
    }
}



