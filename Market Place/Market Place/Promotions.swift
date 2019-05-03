//
//  Promotions.swift
//  Market Place
//
//  Created by Jose Soarez on 5/1/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import UIKit

/**
 Class for Promotion's object, a promotion is composed by a image and some text (in this case two)
 */
class Promotions {
    
    var image : UIImage
    var label1 : String
    var label2 : String
    
    init(label1 : String, label2: String, image : UIImage) {
        self.image = image
        self.label1 = label1
        self.label2 = label2
    }
}
