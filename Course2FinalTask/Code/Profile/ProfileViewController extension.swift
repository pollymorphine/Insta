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
    
    // MARK: Methods
    
    func loadingUser() {
        if NetworkProvider.shared.isOnlineMode == false  {
            loadDataFromCoreData()
        } else {
            userOnlineLoading()
        }
    }
    
    @objc func logout() {
        NetworkProvider.shared.signOut()
        Keychain.shared.deleteToken()
        performSegue(withIdentifier: Identifier.unwindToAuthentication, sender: self)
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
        guard NetworkProvider.shared.isOnlineMode  else {
            Alert.shared.showError(self, message: "Offline")
            spinner?.stopAnimating()
            return
        }
        guard let id = savedUser?.id else { return }
        guard let follow = storyboard?.instantiateViewController(withIdentifier: Identifier.followViewController) as? FollowViewController else { return }
        
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
            case .failure(let networkError):
                DispatchQueue.main.async {
                    Alert.shared.showError(self, message: networkError.error)
                }
            }
        }
    }
    
    func showFollowing() {
        guard NetworkProvider.shared.isOnlineMode  else {
            Alert.shared.showError(self, message: "Offline")
            spinner?.stopAnimating()
            return
        }
        guard let id = savedUser?.id else { return }
        guard let follow = storyboard?.instantiateViewController(withIdentifier:
                                                                    Identifier.followViewController) as? FollowViewController else { return }
        
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
            case .failure(let networkError):
                DispatchQueue.main.async {
                    Alert.shared.showError(self, message: networkError.error)
                }
            }
        }
    }
    
    func followUser(header: ProfileReusableView) {
        guard NetworkProvider.shared.isOnlineMode else {
            Alert.shared.showError(self, message: "Offline")
            return
        }
        guard let id = savedUser?.id else { return }
        guard let text = header.followButton.titleLabel?.text else { return }
        
        if text == "Follow" {
            NetworkProvider.shared.follow(userID: id) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    self.savedUser = UserClass(user: user)
                case .failure(let networkError):
                    DispatchQueue.main.async {
                        Alert.shared.showError(self, message: networkError.error)
                    }
                }
                DispatchQueue.main.async {
                    header.followButton.setTitle("Unfollow", for: .normal)
                    header.followersLabel.text = "Followers: \(self.savedUser!.followedByCount + 0)"
                }
            }
        } else {
            NetworkProvider.shared.follow(userID: id) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    self.savedUser = UserClass(user: user)
                case .failure(let networkError):
                    DispatchQueue.main.async {
                        Alert.shared.showError(self, message: networkError.error)
                    }
                }
                DispatchQueue.main.async {
                    header.followButton.setTitle("Follow", for: .normal)
                    header.followersLabel.text = "Followers: \(self.savedUser!.followedByCount - 1)"
                }
            }
        }
    }
    
    public func userOnlineLoading() {
        // пользователь из feed
        if let user = savedUser {
            guard let id = self.savedUser?.id else { return }
            
            NetworkProvider.shared.findUserPosts(userID: id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let posts):
                    self.posts = posts.compactMap { post in
                        return PostClass.init(post: post)
                    }
                    let sortedPosts = self.posts?.sorted(by: { $0.createdTime > $1.createdTime })
                    self.posts = sortedPosts
                    DispatchQueue.main.async {
                        self.navigationItem.title = user.username
                        self.collectionView.reloadData()
                    }
                case .failure(let networkError):
                    Alert.shared.showError(self, message: networkError.error)
                }
            }
        } else {
            // текущий пользователь
            self.navigationItem.title = savedUser?.username
            
            NetworkProvider.shared.сurrentUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.savedUser = UserClass(user: user)
                    DataProvider.shared.createUserEntity(user)
                    
                    guard let id = self.savedUser?.id else { return }
                    
                    NetworkProvider.shared.findUserPosts(userID: id) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let posts):
                            self.posts = posts.compactMap { post in
                                return PostClass.init(post: post)
                            }
                            let sortedPosts = self.posts?.sorted(by: { $0.createdTime > $1.createdTime })
                            self.posts = sortedPosts
                            DispatchQueue.main.async {
                                self.setupLogout() 
                                self.navigationItem.title = self.savedUser?.username
                                self.collectionView.reloadData()
                            }
                        case .failure(let networkError):
                            Alert.shared.showError(self, message: networkError.error)
                        }
                    }
                case .failure(let networkError):
                    DispatchQueue.main.async {
                        Alert.shared.showError(self, message: networkError.error)
                    }
                }
            }
        }
    }
    
    func loadDataFromCoreData(){
        guard let userFromCoreData = CoreDataManager.shared.fetchData(for: UserEntity.self).first,
              let user = UserClass(user: userFromCoreData) else {
    
            return }
        self.savedUser = user
        let postsFromCoreData:[PostEntity] = CoreDataManager.shared.getUserEntity(userid: user.id)
        self.posts = postsFromCoreData.compactMap({
            (post) -> PostClass? in
            return PostClass.init(post: post)
        })
    }
}



