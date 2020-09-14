//
//  UIImage extension.swift
//  Course2FinalTask
//
//  Created by Polina on 10.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

extension UIImage {
    
    func resized(width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width,
                            height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        return UIGraphicsImageRenderer(size: canvas,
                                       format: format).image {
                                        _ in draw(in: CGRect(origin: .zero,
                                                             size: canvas))
        }
    }
}
