//
//  SearchWorker.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 6/2/21.
//

import Foundation

class SearchWorker {

    enum SearchType: String {
        case album, artist, playlist, track, show, episode
    }

    func search(withToken token: String, search:String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spotify.com"
        urlComponents.path = "/v1/search"
        urlComponents.addQueryItems(fromDictionary: [
            "q": search,
            "response_type": "code",
            "type": SearchType.album.rawValue,
            "limit": 20,
            "offset": 0
        ])
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")

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

//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            do {
//                let tokenResponse = try decoder.decode(TokenDTO.self, from: data)
//                print(tokenResponse)
//            } catch {
//                print(error)
//            }

        }

        task.resume()
    }
}
