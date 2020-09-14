//
//  FollowViewController.swift
//  Course2FinalTask
//
//  Created by Polina on 18.02.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class FollowViewController: UITableViewController {
    
    public var users: [User]?
    public var navigationItemTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationTitle = navigationItemTitle else { return }
        self.navigationItem.title = navigationTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        spinner?.stopAnimating()
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = users else { return 0 }
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath) as? FollowCell
            else { return UITableViewCell() }
        
        if let currentUser0 = users?[indexPath.row] {
            cell.userAvatar.kf.setImage(with: URL(string: currentUser0.avatar))
            cell.userName.text = currentUser0.fullName
        }
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Functions
    
    func showProfile(cell: FollowCell) {
        guard let currentUserCell = currentUserCell(cell: cell) else { return }
        guard let profile = storyboard?.instantiateViewController(withIdentifier: "profileCollectionController") as? ProfileViewController else { return }
        
        NetworkProvider.shared.getUser(userID: currentUserCell.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                profile.user = user
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
    private func currentUserCell(cell: FollowCell) -> User? {
        if let indexPath = tableView.indexPath(for: cell) {
            if let currentUsers = users { return currentUsers[indexPath.row]}
        }
        return nil
    }
}
