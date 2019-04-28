//
//  File.swift
//  Market Place
//
//  Created by Jose Soarez on 4/22/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import UIKit

class Product: Hashable {
    private var name : String
    private var price : Int
    private var category : String
    private var image : UIImage
    
    var hashValue: Int {
        return name.hashValue
    }
    
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
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name
    }

    
}
