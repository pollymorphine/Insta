//
//  FollowViewController.swift
//  Course2FinalTask
//
//  Created by Polina on 18.02.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

final class FollowViewController: UITableViewController {

    public var users: [User]?
    public var navigationItemTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let navigationTitle = navigationItemTitle else { return }
            self.navigationItem.title = navigationTitle
    }

    override func viewDidAppear(_ animated: Bool) {
        //spinner?.stopAnimating()
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = users else { return 0 }
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath) as? FollowCell
            else { return UITableViewCell() }

        if let currentUser = users?[indexPath.row] {
            cell.userAvatar.image = currentUser.avatar
            cell.userName.text = currentUser.fullName
        }

        cell.delegate = self

        return cell
    }

    // MARK: - Functions

    func showProfile(cell: FollowCell) {
        guard let currentUserCell = currentUserCell(cell: cell) else { return }

        guard let profile = storyboard?.instantiateViewController(withIdentifier: "profileCollectionController") as? ProfileViewController else { return }

        userProvider.user(with: currentUserCell.id, queue: queue) { user in
            guard user != nil else {
                alert.showError()
                return
            }
            profile.currentUser = user

            DispatchQueue.main.async {
                self.navigationController?.pushViewController(profile, animated: true)
                spinner?.stopAnimating()
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
