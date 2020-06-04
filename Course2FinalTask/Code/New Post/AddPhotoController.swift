//
//  AddPhotoController.swift
//  Course2FinalTask
//
//  Created by Polina on 10.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

class AddPhotoController: UIViewController {

    @IBOutlet private var addedImage: UIImageView!
    @IBOutlet private var descriptionTextField: UITextField!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        addedImage.image = image
    }

    override func viewDidAppear(_ animated: Bool) {
        spinner?.stopAnimating()
    }

    @IBAction func shareButton(_ sender: Any) {
        spinner?.startAnimating()

        guard let image = image else { return }
        guard let text = descriptionTextField.text else { return }

        postProvider.newPost(with: image, description: text, queue: queue) { post in
            guard let _ = post else {
                alert.showError()
                return
            }
        }
        performSegue(withIdentifier: "unwindToFeedCollection", sender: self)
    }

}
