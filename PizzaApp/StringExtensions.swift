//
//  StringExtensions.swift
//  PizzaApp
//
//  Created by Carlos Carrillo on 8/9/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation

extension String{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
