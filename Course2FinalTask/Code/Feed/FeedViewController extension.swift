//
//  FeedViewController extensions.swift
//  Course2FinalTask
//
//  Created by Polina on 19.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

extension FeedViewController {
    
    // MARK: Methods
    
    func feedLoading() {
        NetworkProvider.shared.getUsersPosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts0):
                self.posts = posts0
                DispatchQueue.main.async {
                    spinner?.startAnimating()
                    self.tableView.reloadData()
                }
            case .fail(let networkError):
                DispatchQueue.main.async {
                    Alert.shared.showError(self, message: networkError.error)
                }
            }
        }
    }
    
    func feedUpdate() {
        NetworkProvider.shared.getUsersPosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let addPost):
                self.posts.insert(contentsOf: addPost, at: 0)
                DispatchQueue.main.async {
                    spinner?.stopAnimating()
                    self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    self.tableView.reloadData()
                }
                
            case .fail(let networkError):
                Alert.shared.showError(self, message: networkError.error)
            }
        }
    }
    
    func showWhoLiked(cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard  let userLiked = storyboard?.instantiateViewController(withIdentifier: Identifier.followViewController) as? FollowViewController else { return }
        
        NetworkProvider.shared.getUsersLikedPost(userID: posts[indexPath.row].id)  { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                userLiked.users = users
                DispatchQueue.main.async {
                    userLiked.navigationItem.title = "Likes"
                    self.navigationController?.pushViewController(userLiked, animated: true)
                    spinner?.stopAnimating()
                }
            case .fail(let networkError):
                DispatchQueue.main.async {
                    Alert.shared.showError(self, message: networkError.error)
                }
            }
        }
    }
    
    func showProfile(cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let profile = storyboard?.instantiateViewController(withIdentifier: Identifier.profileCollectionController) as? ProfileViewController else { return }
        
        NetworkProvider.shared.getUser(userID: posts[indexPath.row].author) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user0):
                profile.user = user0
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(profile, animated: true)
                    spinner?.stopAnimating()
                }
            case .fail(let networkError):
                DispatchQueue.main.async {
                    Alert.shared.showError(self, message: networkError.error)
                }
            }
        }
    }
    
    func tapLikePostButton (cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if cell.likeButton.tintColor == UIColor.lightGray {
            NetworkProvider.shared.likePost(postID: posts[indexPath.row].id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let post):
                    self.post = post
                case .fail(let networkError):
                    DispatchQueue.main.async {
                        Alert.shared.showError(self, message: networkError.error)
                    }
                }
            }
            posts[indexPath.row].currentUserLikesThisPost = true
            posts[indexPath.row].likedByCount += 1
            cell.likeButton.tintColor = .blue
            
        } else if cell.likeButton.tintColor == UIColor.blue {
            NetworkProvider.shared.unlikePost(postID: posts[indexPath.row].id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let post):
                    self.post = post
                case .fail(let networkError):
                    DispatchQueue.main.async {
                        Alert.shared.showError(self, message: networkError.error)
                    }
                }
            }
            posts[indexPath.row].currentUserLikesThisPost = false
            posts[indexPath.row].likedByCount -= 1
            cell.likeButton.tintColor = .lightGray
        }
        tableView.reloadData()
    }
}
