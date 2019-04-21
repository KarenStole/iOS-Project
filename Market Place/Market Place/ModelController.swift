//
//  ModelController.swift
//  Market Place
//
//  Created by Jose Soarez on 4/21/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import UIKit

class ModelController {
    
    //Function that get the images's references from Promotions.plist and parse it into an array of UIImage
    func getPromotionsImages() -> [UIImage] {
        var imagesArray : [UIImage] = []
        
        //Getting the file's content
        let path = Bundle.main.path(forResource: "Promotions", ofType: "plist")
        let contentOfFile = NSDictionary(contentsOfFile: path!)
        let promotions = contentOfFile as! [String: [String]]
       let keyPromotions = contentOfFile!.allKeys as! [String]
        
        //Getting the image's names (.png) and parse it into UIImage
        for item in 0..<keyPromotions.count {
            let promoImageNameFromFile = UIImage(named: promotions[keyPromotions[item]]![2])
            imagesArray.append(promoImageNameFromFile!)
        }
        
        return imagesArray
    }
}
