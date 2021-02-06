//
//  URLComponents.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 6/2/21.
//

import Foundation

extension URLComponents {
    mutating func addQueryItems(fromDictionary dictionary: [String: LosslessStringConvertible]) {
        let queryItems = dictionary.map { (arg0) -> URLQueryItem in

            let (key, value) = arg0
            return URLQueryItem(name: key, value:(String(describing: value)))
        }
        self.queryItems = queryItems
    }
}
