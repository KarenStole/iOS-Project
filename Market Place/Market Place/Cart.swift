//
//  File.swift
//  Market Place
//
//  Created by Jose Soarez on 4/25/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
class Cart  {
    
    var cart : [Product : Int]
    
    init(dictionary : [Product : Int]) {
        cart = dictionary
    }
    
    func cantOfProducts() -> Int {
        var cant = 0
        
        for product in self.cart{
            if(product.value != 0){
                cant+=1
            }
        }
        return cant
    }
    
    func getTotal() -> Int {
        
        var sum = 0
        let products = self.cart.filter { (arg0) -> Bool in
            let (_, value) = arg0
            return value != 0
        }
        for product in products{
            let price = product.key.getProductPrice()
            let units = product.value
            sum += (price*units)
        }
        return sum
    }
    static func initCart() -> Cart {
        var dictionary = [Product : Int]()
        for product in ModelManager.getProductsFromFile(){
            dictionary[product] = 0
        }
        return Cart(dictionary: dictionary)
    }
    
}
