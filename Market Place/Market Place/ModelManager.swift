//
//  ModelController.swift
//  Market Place
//
//  Created by Jose Soarez on 4/21/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper

class ModelManager {

    static let sharedModelManager = ModelManager()
    var cart = Cart.initCart()
    var emptyCart: Bool {
        get {
            return isCartEmpty(cart: cart)
        }
    }
    static let url = "https://us-central1-ucu-ios-api.cloudfunctions.net"
    var token: String = ""

    private init(){
        //Getting the token only one time
        AuthenticationManager.shared.authenticate(onCompletion: {response in
            self.token = "Bearer \(response.token)"
        })
    }
    
    //#############    FUNCTIONS TO MANAGE PROMOTIONS ###############################################
    //Function that get the images's references from Promotions.plist and parse it into an array of UIImage
    static func getPromotionsFromApi( completionHandler: @escaping ( [Promotions]?, Error?) -> Void) {
        print("Request to: \(ModelManager.url)/products")
        Alamofire.request("\(ModelManager.url)/promoted", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseArray { (  response: DataResponse<[Promotions]>) in
            switch response.result {
            case .success:
                completionHandler(response.value, nil)
                print("success")
            case .failure(let error):
                completionHandler(nil, error)
                print("error")
            }
            
        }
    }
    
    //#############    FUNCTIONS TO MANAGE PRODUCTS #################################################
    
    //Get all the caregories form Products.plist
    static func getProductCategories(listOfProducts :[Product]) -> [String] {
        var categoryArray : [String] = []
        
        for product in listOfProducts{
            if(!categoryArray.contains(product.category!)){
                categoryArray.append(product.category!)
            }
        }
        return categoryArray
    }
    
    
    //Get all the products from Products.plist
    static func getProductsFromApi( completionHandler: @escaping ( [Product]?, Error?) -> Void) {
        print("Request to: \(ModelManager.url)/products")
            Alamofire.request("\(ModelManager.url)/products", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseArray { (  response: DataResponse<[Product]>) in
            switch response.result {
            case .success:
                completionHandler(response.value, nil)
                print("success")
            case .failure(let error):
                completionHandler(nil, error)
                print("error")
            }
        
        }
    }
    

    
    //Get the list of products one caregory
    static func  getProductForCategory(caregoryIndex : Int, listOfProducts: [Product]) -> [Product] {
        let category = getProductCategories(listOfProducts: listOfProducts)[caregoryIndex]
        var productForEachCategory : [Product] = []

            for product in 0..<listOfProducts.count{
                if  listOfProducts[product].category! == category {
                        productForEachCategory.append(listOfProducts[product])
                    }
                }

        return productForEachCategory
        

    }
    
    //Get a list of products names
    static func getProductsName(products : [Product]) -> [String]{
        var productsNames : [String] = []
        for product in products{
            productsNames.append(product.name!)
        }
        return productsNames
    }
    
    
    //#############    FUNCTIONS TO MANAGE THE CART #################################################
    
    // Update the quantity of a product in the cart, if the product isn't in the cart, create a new CartItem
    func addProductIntoTheCart(product : Product, cart : Cart) {
        let item = CartItem()
        //Check if in the cart is a item with the current product
        let itemCart = self.cart.cart.filter { (arg0) -> Bool in
            let (cartItem) = arg0
            return cartItem.product == product
        }
        //If there isn't a item with the product, add ir to the cart
        if(itemCart.isEmpty){
            item.product = product
            item.quantity = 1
            cart.cart.append(item)
        }
        //Otherwise just add one to the quantity
        else{
            if let quantity = itemCart.first?.quantity{
                itemCart.first?.quantity = (quantity + 1)
            }
            
            
        }
        
    }
    
    func removeProductIntoTheCart(product : Product, cart : Cart) {
        let itemCart = self.cart.cart.filter { (arg0) -> Bool in
            let (cartItem) = arg0
            return cartItem.product == product
        }
        if(!itemCart.isEmpty){
            if let quantity = itemCart.first?.quantity{
                itemCart.first?.quantity = (quantity - 1)
                //If the quantity is equal before the subtraction, just delete it into the cart
                if(quantity == 1){
                    if let index = cart.cart.index(of: itemCart.first!) {
                        cart.cart.remove(at: index)
                    }
                }
            }
        }
        
    }

    
    //Check if the cart is empty
    func isCartEmpty(cart : Cart) -> Bool {
        if(cart.cart.isEmpty){
            return true
        }else{
            return false
        }
    }
    
    //Making the chack out
    static func postCheckOut( token: String, cart: Cart, completionHandler: @escaping ( String?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        var parameters: [String: [[String:Int]]] = [
            "cart": []
        ]
        //Preparing the Json
        for item in cart.cart{
            if(item.quantity != 0){
                parameters["cart"]!.append(["product_id": item.product.id!, "quantity": item.quantity])
            }
            
        }
        print("\(ModelManager.url)/checkout")
        Alamofire.request("\(ModelManager.url)/checkout", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500).responseString(completionHandler: {response in
            switch response.result {
            case .success:
                completionHandler(response.value, nil)
                print("success")
                print(response.value!)
            case .failure(let error):
                print(response.description)
                completionHandler(nil, error)
                print("error")
                
            }
        })
    }
}

