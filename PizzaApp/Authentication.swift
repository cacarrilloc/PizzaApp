//
//  Authentication.swift
//  PizzaApp
//
//  Created by Carlos Carrillo on 8/11/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation
import Firebase


protocol loginDelegate:class {
    func appStateDidChange(to value:Bool)
}


class Authentication {
    static let shared = Authentication()
    weak var currentVC:loginDelegate?
    public let fireBaseAuth = Auth.auth()
    
    var isLogedIn:Bool = false {
        didSet(newValue) {
            currentVC?.appStateDidChange(to: newValue)
        }
    }
    
    init() {
        fireBaseAuth.addStateDidChangeListener{
            [unowned self](auth, user) in
            guard user == nil else {
                self.isLogedIn = true
                return
            }
            self.isLogedIn = false
            print("Listener got called")
        }
    }
}
