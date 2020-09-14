//
//  Photos.swift
//  Course2FinalTask
//
//  Created by Polina on 17.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class Photos {
    
    static var shared = Photos()
    
    private init() { }
    
    func setGallery() -> [UIImage] {
        var gallery = [UIImage]()
        
        if let photo1 = UIImage(named: "new1") {
            gallery.append(photo1)
        }
        
        if let photo2 = UIImage(named: "new2") {
            gallery.append(photo2)
        }
        
        if let photo3 = UIImage(named: "new3") {
            gallery.append(photo3)
        }
        
        if let photo4 = UIImage(named: "new4") {
            gallery.append(photo4)
        }
        
        if let photo5 = UIImage(named: "new5") {
            gallery.append(photo5)
        }
        
        if let photo6 = UIImage(named: "new6") {
            gallery.append(photo6)
        }
        
        if let photo7 = UIImage(named: "new7") {
            gallery.append(photo7)
        }
        
        if let photo8 = UIImage(named: "new8") {
            gallery.append(photo8)
        }
        return gallery
    }
}

