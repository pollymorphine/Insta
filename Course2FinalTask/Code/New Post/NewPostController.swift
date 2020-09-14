//
//  NewPostController.swift
//  Course2FinalTask
//
//  Created by Polina on 29.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class  NewPostController: UICollectionViewController {

    private var photos = [UIImage]()
    private var cellPhoto: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        photos = Photos.shared.setGallery()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.newPostCell, for: indexPath) as? NewPostCell
            else { return UICollectionViewCell() }

         let photo = photos[indexPath.row]
         cell.newPostImage.image = photo

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? NewPostCell
        cellPhoto = cell?.newPostImage

        performSegue(withIdentifier: Identifier.showFilltersMenu, sender: nil)
        spinner?.startAnimating()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? FilterViewController else { return }
        destination.imageCell = self.cellPhoto
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension NewPostController: UICollectionViewDelegateFlowLayout {

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
