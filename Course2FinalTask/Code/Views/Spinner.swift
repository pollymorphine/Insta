//
//  Spinner.swift
//  Course2FinalTask
//
//  Created by Polina on 30.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

public class Spinner: UIActivityIndicatorView {
    
 private var optionalView: UIView?

    init(view: UIView) {
         let containerView = UIView()
         containerView.frame = view.frame
         containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)

         super.init(frame: view.frame)
         self.center = view.center

         containerView.isHidden = true
         containerView.addSubview(self)
         optionalView = containerView

        guard let optionalView = optionalView else { return }
        view.addSubview(optionalView)
     }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func startAnimating() {
        super.startAnimating()
        self.style = .whiteLarge
        guard let spinner = optionalView else { return }
        spinner.isHidden = false
    }

    public override func stopAnimating() {
        guard let spinner = optionalView else { return }
        spinner.isHidden = true
        super.stopAnimating()
    }

}

public var spinner: Spinner?

