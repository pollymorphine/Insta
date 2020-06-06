//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Polina on 18.02.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

final class FeedViewController: UITableViewController {
    
    @IBAction func unwindToFeedViewController(segue: UIStoryboardSegue) { }
    
    var user: User?
    private var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.tabBarController?.view else { return }
        spinner = Spinner(view: view)
        
        postProvider.feed(queue: queue) { [weak self] posts in
            guard let posts = posts else {
                alert.showError()
                return
            }
            self?.posts = posts
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        postProvider.feed(queue: queue) { [weak self] addPost in
            guard let sharedPost = addPost else {
                alert.showError()
                return
            }
            guard let posts = self?.posts else { return }
            if sharedPost.count > posts.count {
                
                DispatchQueue.main.async {
                    spinner?.stopAnimating()
                    self?.posts = sharedPost
                    self?.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell
            else { return UITableViewCell() }
        
        cell.configure(with: posts[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    // MARK: Functions
    
    func showWhoLiked(cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        guard  let userLiked = storyboard?.instantiateViewController(withIdentifier: "followViewController") as? FollowViewController else { return }
        
        postProvider.usersLikedPost(with: posts[indexPath.row].id, queue: queue) { users in
            guard users != nil else {
                alert.showError()
                return
            }
            userLiked.users = users
            
            DispatchQueue.main.async {
                userLiked.navigationItem.title = "Likes"
                self.navigationController?.pushViewController(userLiked, animated: true)
                spinner?.stopAnimating()
            }
        }
    }
    
    func showProfile(cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        guard let profile = storyboard?.instantiateViewController(withIdentifier: "profileCollectionController") as? ProfileViewController else { return }
        
        userProvider.user(with: posts[indexPath.row].author, queue: queue) { currentUser in
            guard currentUser != nil else {
                alert.showError()
                return
            }
            profile.currentUser = currentUser
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(profile, animated: true)
                spinner?.stopAnimating()
            }
        }
    }
    
    func tapLikePostButton (cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if cell.likeButton.tintColor == UIColor.lightGray {
            
            postProvider.likePost(with: posts[indexPath.row].id, queue: queue) { likePost in
                guard let likePost = likePost else {
                    alert.showError()
                    return
                }
                self.posts[indexPath.row] = likePost
            }
            posts[indexPath.row].currentUserLikesThisPost = true
            posts[indexPath.row].likedByCount += 1
            cell.likeButton.tintColor = .blue
            
        } else if cell.likeButton.tintColor == UIColor.blue {
            postProvider.likePost(with: posts[indexPath.row].id, queue: queue) { likePost in
                guard let likePost = likePost else {
                    alert.showError()
                    return
                }
                self.posts[indexPath.row] = likePost
            }
            posts[indexPath.row].currentUserLikesThisPost = false
            posts[indexPath.row].likedByCount -= 1
            cell.likeButton.tintColor = .lightGray
        }
        self.tableView.reloadData()
    }
}

