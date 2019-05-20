//
//  AuthenticationResponse.swift
//  EjercicioApi
//
//  Created by Alvaro Rose on 5/13/19.
//  Copyright © 2019 Alvaro Rose. All rights reserved.
//

import Foundation

class AuthenticationResponse {
    var token: String
    
    init(token: String) {
        print(token)
        self.token = token
    }
}
