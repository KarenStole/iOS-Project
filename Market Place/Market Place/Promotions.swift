//
//  Promotions.swift
//  Market Place
//
//  Created by Jose Soarez on 5/1/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
/**
 Class for Promotion's object, a promotion is composed by a image and some text (in this case two)
 */
class Promotions: Mappable {

    var image : String?
    var label1 : String?
    var label2 : String?
    
    init(){}
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    init(label1 : String, label2: String, image : String) {
        self.image = image
        self.label1 = label2
        self.label2 = label1
    }
    func mapping(map: Map) {
        label1 <- map["name"]
        label2 <- map["description"]
        image <- map["photoUrl"]
    }
}
