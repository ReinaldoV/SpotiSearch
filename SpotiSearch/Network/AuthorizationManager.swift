//
//  AuthorizationManager.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 4/2/21.
//

import Foundation

class AuthorizationManager {

    let clientId = ""
    let redirectURI: URL = URL(string: "")!
    let scope = "user-read-private"

    func requestAuthorizationURL() -> URL? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "accounts.spotify.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = urlQueryDictionary([
            "client_id": self.clientId,
            "response_type": "code",
            "redirect_uri": redirectURI.absoluteString,
            "scope": scope,
            "show_dialog": false
        ])
        return urlComponents.url
    }

    private func urlQueryDictionary(_ dictionary: [String: LosslessStringConvertible?]) -> [URLQueryItem] {
        return dictionary.map { (arg0) -> URLQueryItem in

            let (key, value) = arg0
            return URLQueryItem(name: key, value:(String(describing: value)))
        }
    }

}
