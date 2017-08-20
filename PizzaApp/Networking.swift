//
//  Networking.swift
//  PizzaApp
//
//  Created by Carlos Carrillo on 8/10/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation

enum NetworkingError:Error {
    case UrlNotValid
}


class Networking {
    static func getData(from url:String, completion:@escaping(Error?,Data?) -> ()) {
        guard let url = URL(string: url) else {
            completion(NetworkingError.UrlNotValid, nil)
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            completion(error, data)
        }
        task.resume()
    }
}
