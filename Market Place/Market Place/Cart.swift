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

    var cart : [Product : Int]
    var date : String = ""

    required convenience init?(map: Map) {
        self.init(dictionary: [:])
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        cart <- map["products"]
    }
    
    init(dictionary : [Product : Int]) {
        cart = dictionary
    }
    
    //Getting the total products in the cart
    func cantOfProducts() -> Int {
        var cant = 0
        
        for product in self.cart{
            if(product.value != 0){
                cant+=1
            }
        }
        return cant
    }
    
    //Getting the total price of the cart
    func getTotal() -> Int {
        
        var sum = 0
        let products = self.cart.filter { (arg0) -> Bool in
            let (_, value) = arg0
            return value != 0
        }
        for product in products{
            let price = product.key.price
            let units = product.value
            sum += (price!*units)
        }
        return sum
    }
    
    // Initialize a cart: A dictionary with all product in the market but with quiantity 0
    static func initCart(arrayOfProducts : [Product]?) -> Cart {
        var dictionary = [Product : Int]()
        if let arrayOfProducts = arrayOfProducts{
        for product in arrayOfProducts{
                dictionary[product] = 0
        }
        }
    
        return Cart(dictionary: dictionary)
    }
    
}
