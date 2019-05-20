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
    var cart = Cart.initCart(arrayOfProducts: nil)
    var emptyCart: Bool {
        get {
            return isCartEmpty(cart: cart)
        }
    }
    static let url = "https://us-central1-ucu-ios-api.cloudfunctions.net"
    var token: String = ""

    private init(){
        AuthenticationManager.shared.authenticate(onCompletion: {response in
            self.token = "Bearer \(response.token)"
        })
    }
    
    //#############    FUNCTIONS TO MANAGE PROMOTIONS ###############################################
    //Function that get the images's references from Promotions.plist and parse it into an array of UIImage
    static func getPromotionsFromApi( completionHandler: @escaping ( [Promotions]?, Error?) -> Void) {
        //acordarse de poner el metodo
        print("\(ModelManager.url)/products")
        Alamofire.request("\(ModelManager.url)/promoted").validate().responseArray { (  response: DataResponse<[Promotions]>) in
            switch response.result {
            case .success:
                completionHandler(response.value, nil)
                print("success")
            case .failure(let error):
                completionHandler(response.value, error)
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
        //acordarse de poner el metodo
        print("\(ModelManager.url)/products")
            Alamofire.request("\(ModelManager.url)/products").validate().responseArray { (  response: DataResponse<[Product]>) in
            switch response.result {
            case .success:
                completionHandler(response.value, nil)
                print("success")
            case .failure(let error):
                completionHandler(response.value, error)
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
    
    // Update the quantity of a product in the cart
    func addProductIntoTheCart(product : Product, quantity : Int, cart : Cart) {
        cart.cart.updateValue(quantity, forKey: product)
    }
    
    //Check if the cart is empty
    func isCartEmpty(cart : Cart) -> Bool {
        var isEmpty = false
        for productInCart in cart.cart{
            if productInCart.value != 0 {
                isEmpty = true
                break
            }
        }
        return isEmpty
    }
    
    static func postCheckOut( token: String, cart: Cart, completionHandler: @escaping ( String?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        var parameters: [String: [Any]] = [
            "cart": []
        ]
        for item in cart.cart{
            if(item.value != 0){
                parameters["cart"]?.append(["product_id": item.key.id!, "quantity": item.value])
            }
            
        }
        print(parameters)
        print(headers)
        //acordarse de poner el metodo
        print("\(ModelManager.url)/checkout")
        Alamofire.request("\(ModelManager.url)/checkout", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<500).responseData(completionHandler: {response in
            switch response.result {
            case .success:
                completionHandler(response.description, nil)
                print("success")
            case .failure(let error):
                print(response.description)
                completionHandler(response.description, error)
                print("error")
                
            }
        })
    }
}

