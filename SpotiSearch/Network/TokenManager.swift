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
        self.apiToken(withPetitionBody: [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI].percentEncoded())
    }

    func refreshToken(token: String) {
        self.apiToken(withPetitionBody: [
            "grant_type": "refresh_token",
            "refresh_token": token].percentEncoded())
    }

    private func apiToken(withPetitionBody body: Data?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "accounts.spotify.com"
        urlComponents.path = "/api/token"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let ids = self.idsEncoded() else { return }
        request.addValue(ids, forHTTPHeaderField: "Authorization")
        request.httpBody = body

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
            print("responseString = \(String(describing: responseString))")

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let tokenResponse = try decoder.decode(TokenDTO.self, from: data)
                print(tokenResponse)
            } catch {
                print(error)
            }

        }

        task.resume()
    }

    private func idsEncoded() -> String? {

        guard let encodedString = "\(self.clientId):\(self.clientSecret)".data(using: .utf8)?.base64EncodedString()
        else { return nil }

        return "Basic \(encodedString)"

    }
}

struct TokenDTO: Codable {
    let accessToken: String
    let expiresIn: Double
    let refreshToken: String
}
