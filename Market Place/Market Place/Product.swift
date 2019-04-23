//
//  File.swift
//  Market Place
//
//  Created by Jose Soarez on 4/22/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import UIKit

class Product  {
    
    var name : String
    var price : Int
    var category : String
    var image : UIImage
    
    init(name : String, price : Int, category : String, image : UIImage) {
        self.name = name
        self.price = price
        self.category = category
        self.image = image
    }
    
    func getProductName() -> String {
        return self.name
    }
    func getProductPrice() -> Int {
        return self.price
    }
    func getProductCategory() -> String {
        return self.category
    }
    func getProductImage() -> UIImage {
        return self.image
    }
    
    func setProductName(name : String) {
        self.name = name
    }
    func setProductPrice(price : Int) {
        self.price = price
    }
    func setProductCategory(category : String) {
        self.category = category
    }
    func setProductImage(image : UIImage) {
        self.image = image
    }
    
}
