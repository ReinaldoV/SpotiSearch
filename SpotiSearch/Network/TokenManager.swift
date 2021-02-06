//
//  TokenManager.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 6/2/21.
//

import Foundation

class TokenManager {

    let redirectURI = "SpotiSearch://login-callback"
    let clientId = "51c228c4d5934113b884395161a20396"
    let clientSecret = "4a0418c57dc9460fbc46636503d64745"

    func requestToken(withAuthorizationCode code: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "accounts.spotify.com"
        urlComponents.path = "/api/token"
//        urlComponents.addQueryItems(fromDictionary: [
//            "grant_type": "authorization_code",
//            "code": code,
//            "redirect_uri": redirectURI,
//            "client_id": clientId,
//            "client_secret": clientSecret
//        ])
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI,
            "client_id": clientId,
            "client_secret": clientSecret
        ].percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }

        task.resume()
    }
}