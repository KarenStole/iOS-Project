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
    var cart = Cart.initCart()
    
    private init(){}
    
    //Getting all the purchases
    static func getCartsFromApi( token: String, completionHandler: @escaping ( [Cart]?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        print(token)
        print("Request yo: \(ModelManager.url)/purchases")
        Alamofire.request("\(ModelManager.url)/purchases", method: .get, headers: headers).validate().responseArray{ (  response: DataResponse<[Cart]>) in
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
}

