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
}
