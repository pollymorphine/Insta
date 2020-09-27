//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Polina on 18.02.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class FeedViewController: UITableViewController {
    
    @IBAction func unwindToFeedViewController(segue: UIStoryboardSegue) { }
    
    var user: User?
    var post: Post?
    var posts = [PostClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.tabBarController?.view else { return }
        spinner = Spinner(view: view)
        spinner?.stopAnimating()
        
        feedLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        feedUpdate()
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.feedCell, for: indexPath) as? FeedCell
            else { return UITableViewCell() }
        
        cell.configure(with: posts[indexPath.row])
        cell.delegate = self
        return cell
    }
}

