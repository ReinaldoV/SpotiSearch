//
//  AuthorizationManager.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 4/2/21.
//

import Foundation

class AuthorizationManager {

    let clientId = "51c228c4d5934113b884395161a20396"
    let redirectURI = "SpotiSearch://login-callback"
    let scope = "user-read-private"

    func requestAuthorizationURL() -> URL? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "accounts.spotify.com"
        urlComponents.path = "/authorize"
        urlComponents.addQueryItems(fromDictionary: [
            "client_id": self.clientId,
            "response_type": "code",
            "redirect_uri": redirectURI,
            "scope": scope,
            "show_dialog": true
        ])
        return urlComponents.url
    }
}
