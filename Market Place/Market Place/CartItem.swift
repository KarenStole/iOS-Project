//
//  CartItem.swift
//  Market Place
//
//  Created by Jose Soarez on 5/21/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import  ObjectMapper

class CartItem: Mappable, Equatable {
    
    var product = Product()
    var quantity = Int()
    
    init() {
    }
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    func mapping(map: Map) {
        self.product <- map["product"]
        self.quantity <- map["quantity"]
    }
    
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.product == rhs.product
    }
}
