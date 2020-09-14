//
//  FilterViewController.swift
//  Course2FinalTask
//
//  Created by Polina on 03.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class FilterViewController: UIViewController {

    @IBOutlet private var bigFilterImageView: UIImageView!
    @IBOutlet private var filterCollection: UICollectionView!

    var imageCell: UIImageView!
    private var filterImage: UIImage?
    private let reuseIdentifier = "filterCell"
    let filterGroup = DispatchGroup()

    private let filterNames = ["CIColorInvert",
                               "CIPixellate",
                               "CISpotColor",
                               "CISepiaTone",
                               "CISpotLight",
                               "CIZoomBlur",
                               "CIPhotoEffectNoir"]

    override func viewDidLoad() {
        super.viewDidLoad()

        bigFilterImageView.image = imageCell.image
        filterImage = bigFilterImageView.image?.resized(width: 50.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        spinner?.stopAnimating()
    }
}

// MARK: UICollectionViewDataSource

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FilterCell
            else { return UICollectionViewCell() }

        cell.delegate = self
        cell.filterName.text = filterNames[indexPath.row]
        cell.smallFilterImageView.image = filterImage

        var filteredImage: UIImage?
        DispatchQueue.global(qos: .userInitiated).async(group: filterGroup) {
            guard let ciimage = CIImage(image: self.filterImage!) else { return }
            filteredImage = self.applyFilter(name: (self.filterNames[indexPath.item]), params: [kCIInputImageKey: ciimage])
        }

        filterGroup.notify(queue: .main) {
            cell.smallFilterImageView.image = filteredImage
            cell.filterName.text = self.filterNames[indexPath.item]
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        spinner?.startAnimating()

        var filteredImage: UIImage?
        guard let image = self.imageCell.image else { return }
        guard let ciimage = CIImage(image: image) else { return }
        DispatchQueue.global(qos: .userInitiated).async(group: filterGroup) {
            filteredImage = self.applyFilter(name: self.filterNames[indexPath.item], params: [kCIInputImageKey: ciimage])
        }

        filterGroup.notify(queue: .main) {
            self.bigFilterImageView.image = filteredImage
            spinner?.stopAnimating()
        }
    }

    // MARK: Functions

    private func applyFilter(name: String, params: [String: Any]) -> UIImage? {
        let context = CIContext()
        guard let filter = CIFilter(name: name, parameters: params),
            let outputImage = filter.outputImage,
            let cgiimage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
        }
        return UIImage(cgImage: cgiimage)
    }

    @IBAction func nextButton(_ sender: Any) {
        spinner?.startAnimating()
        performSegue(withIdentifier: "showDescriptionView", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AddPhotoController else { return }
        destination.image = self.bigFilterImageView.image
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension FilterViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120.0, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
}
