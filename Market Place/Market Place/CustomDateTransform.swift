//
//  CustomDateTransform.swift
//  PrimerObligatorio
//
//  Created by Alvaro Rose on 5/22/19.
//  Copyright © 2019 Alvaro Rose. All rights reserved.
//

import ObjectMapper

class CustomDateTransform: TransformType {
    typealias Object = Date
    typealias JSON = String
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let dateString = value as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.timeZone = TimeZone.current
            return formatter.date(from: dateString)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
        if let date = value {
            return formatter.string(from: date)
        }
        return nil
    }
}
