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

 func showError() {
    let alertController = UIAlertController(title: "Unknown error!",
                                            message: "Please, try again later.",
                                            preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK",
                                 style: .default,
                                 handler: nil)
    alertController.addAction(okAction)
   }
}

public let alert = Alert()
