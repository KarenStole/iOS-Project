//
//  File.swift
//  Market Place
//
//  Created by Jose Soarez on 4/25/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import ObjectMapper
class Cart : Mappable{

    var cart : [CartItem] = []
    var date : Date? = nil

    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        date <- (map["date"], CustomDateTransform())
        cart <- map["products"]
    }
    
    init() {
    }
    
    //Getting the total products in the cart
    func cantOfProducts() -> Int {
        var cant = 0
        
        for product in self.cart{
            if(product.quantity != 0){
                cant+=1
            }
        }
        return cant
    }
    
    //Getting the total price of the cart
    func getTotal() -> Double {
        
        var sum : Double = 0
        let products = self.cart.filter { (arg0) -> Bool in
            let (cartItem) = arg0
            return cartItem.quantity != 0
        }
        for product in products{
            let price = product.product?.price
            let units = product.quantity
            sum += (price! * (Double(units!)))
        }
        return sum
    }
    
    static func getProductQuantity(product : Product, cart: Cart) -> Int {
            let cartItem = cart.cart.filter { (arg0) -> Bool in
                let (cartItem) = arg0
                return cartItem.product == product
            }
        if let first = cartItem.first {
            return first.quantity!
        }else{
            return 0
        }
        
        //Adding one of the selected product in the cart
        
    }
    
    // Initialize a cart: A dictionary with all product in the market but with quiantity 0
    static func initCart() -> Cart {
        return Cart()
    }
    
}
