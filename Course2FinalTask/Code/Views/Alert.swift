//
//  Alert.swift
//  Course2FinalTask
//
//  Created by Polina on 12.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

public class Alert {
    
    static var shared = Alert()

    func showError(_ viewController: UIViewController, message: String) {
  DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(okAction)
    viewController.present(alert, animated: true)
        }
    }
}


//public let alert = Alert()
