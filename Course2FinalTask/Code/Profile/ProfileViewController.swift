//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Polina on 18.02.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

final class ProfileViewController: UICollectionViewController {
    
    var user: User?
    var posts:[Post]?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        userLoading()
    }
}
    // MARK: UICollectionViewDataSource

    extension ProfileViewController {
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            guard let posts = posts else { return [Post]().count }
            return posts.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.profileCell, for: indexPath) as? ProfileCell
                else { return UICollectionViewCell() }
            
            guard let currentPost = posts?[indexPath.row] else { return cell }
            cell.profileImage.kf.setImage(with: URL(string: currentPost.image))
            
            return cell
        }
        
        override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let kind = UICollectionView.elementKindSectionHeader
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifier.profileReusableView, for: indexPath) as? ProfileReusableView
                else { return UICollectionReusableView() }
            
            guard let user = user else { return headerView }
            headerView.configure(user: user)
            
            headerView.delegate = self
            
            return headerView
        }
    }

    // MARK: UICollectionViewDataSource


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
