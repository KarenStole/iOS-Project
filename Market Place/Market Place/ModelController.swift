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
    
    func getProductCategoryFromFile() -> [String] {
        var categoryArray : [String] = []
        
        let path = Bundle.main.path(forResource: "Products", ofType: "plist")
        let contetOfFile = NSDictionary(contentsOfFile: path!)
        categoryArray = contetOfFile!.allKeys as! [String]
        return categoryArray
    }
    
    func getProductsFromFile() -> [Product] {
        var productArray : [Product] = []
        
        //Getting file's content
        let path = Bundle.main.path(forResource: "Products", ofType: "plist")
        let contentOfFile = NSDictionary(contentsOfFile: path!)
        let categories = getProductCategoryFromFile()
        let products = contentOfFile as! [String: [Array<Any>]]
        
        for category in 0..<categories.count {
            let listOfProductsOneCategory = products[categories[category]]
            for product in 0..<listOfProductsOneCategory!.count{
                let name = listOfProductsOneCategory![product][0]
                let price = listOfProductsOneCategory![product][1]
                let image = UIImage(named: listOfProductsOneCategory![product][2] as! String)
                let productObject = Product(name: name as! String, price: price as! Int, category: categories[category], image: image!)
                productArray.append(productObject)
            }
        }
        return productArray
    }
    
    func  getProductForCategory(caregoryIndex : Int) -> [Product] {
        let category = getProductCategoryFromFile()[caregoryIndex]
        var productForEachCategory : [Product] = []
        
        for product in 0..<getProductsFromFile().count{
            if  getProductsFromFile()[product].getProductCategory() == category {
                productForEachCategory.append(getProductsFromFile()[product])
            }
        }
        return productForEachCategory
    }
    
    func getProductsName(products : [Product]) -> [String]{
        var productsNames : [String] = []
        for product in products{
            productsNames.append(product.getProductName())
        }
        return productsNames
    }
}
