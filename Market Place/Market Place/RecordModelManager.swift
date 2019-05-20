//
//  RecordModelManager.swift
//  Market Place
//
//  Created by Jose Soarez on 5/19/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class RecordModelManager {
    
    static let sharedModelManager = RecordModelManager()
    var cart = Cart.initCart(arrayOfProducts: nil)
    
    private init(){}
    
    static func getCartsFromApi( token: String, completionHandler: @escaping ( [Cart]?, Error?) -> Void) {
        //acordarse de poner el metodo
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        print(token)
        print("\(ModelManager.url)/purchases")
        Alamofire.request("\(ModelManager.url)/purchases", method: .get, headers: headers).validate().responseArray{ (  response: DataResponse<[Cart]>) in
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
}

