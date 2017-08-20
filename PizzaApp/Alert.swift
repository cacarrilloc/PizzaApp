//
//  File.swift
//  PizzaApp
//
//  Created by Carlos Carrillo on 8/10/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation
import UIKit


class Alert {
    static func createAlert(title:String, message:String, completion:(() -> Void)? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "ok", style: .default) {
            (action) in
            completion?()
        }
        alert.addAction(ok)
        return alert
    }
    
    static func createYesNoAlert(title:String, message:String, yesCompletion:@escaping()->(), noCompletion:(()->())? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "yes", style: .default){
            (action) in
            yesCompletion()
        }
        
        let no = UIAlertAction(title: "no", style: .default){
            (action) in
            noCompletion?()
        }
            
        alert.addAction(yes)
        alert.addAction(no)
        return alert
    }
}
