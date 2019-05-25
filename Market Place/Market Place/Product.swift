//
//  File.swift
//  Market Place
//
//  Created by Jose Soarez on 4/22/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Product: Hashable, Mappable {
    
    var name : String?
    var price : Double?
    var category : String?
    var image : String?
    var id : Int?
    
    init() {
    }
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
        category <- map["category"]
        image <- map["photoUrl"]
    }
    var hashValue: Int {
        return name.hashValue
    }
    
    init(name : String, price : Double, category : String, image : String) {
        self.name = name
        self.price = price
        self.category = category
        self.image = image
    }
        
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }

    
}
