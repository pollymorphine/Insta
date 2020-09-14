//
//  AddPhotoController.swift
//  Course2FinalTask
//
//  Created by Polina on 10.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

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
        guard let imageData = image.pngData() else { return }
        
        NetworkProvider.shared.addNewPost(with: imageData.base64EncodedString(), description: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindToFeedCollection", sender: self)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .fail(let networkError):
                Alert.shared.showError(self, message: networkError.error)
            }
        }
    }
}

