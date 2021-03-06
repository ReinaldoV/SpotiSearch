//
//  SearchManager.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 6/2/21.
//

import Foundation

protocol SearchManagerProtocol {
    func currentTask() -> URLSessionDataTask?
    func search(_ search: String,
                for categories: [SearchCategories],
                withToken token: String,
                onSuccess: @escaping ([SearchResultDTO]) -> Void,
                onError: ((_ error: Error?) -> Void)?)
}

enum SearchCategories: String {
    case album, artist, track, playlist, show, episode

    init(withSearchItemType type: SearchItemType) {
        switch type {
        case .album:
            self = .album
        case .artist:
            self = .artist
        case .track:
            self = .track
        }
    }
}

class SearchManager: SearchManagerProtocol {

    static var task: URLSessionDataTask?

    func currentTask() -> URLSessionDataTask? {
        return SearchManager.task
    }

    func search(_ search: String,
                for categories: [SearchCategories],
                withToken token: String,
                onSuccess: @escaping ([SearchResultDTO]) -> Void,
                onError: ((_ error: Error?) -> Void)?) {
        SearchManager.task?.cancel()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spotify.com"
        urlComponents.path = "/v1/search"
        urlComponents.addQueryItems(fromDictionary: [
            "q": search,
            "response_type": "code",
            "type": categories.map { $0.rawValue }.joined(separator: ","),
            "limit": 20,
            "offset": 0
        ])
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        SearchManager.task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { // check for fundamental networking error
                print("error", error ?? "Unknown error")
                onError?(error)
                return
            }

            guard (200 ... 299) ~= response.statusCode else { // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                onError?(nil)
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            do {
                let resultDTO = try decoder.decode(ResponseResultDTO.self, from: data)
                let combined = [resultDTO.albums?.items, resultDTO.artists?.items, resultDTO.tracks?.items]
                    .compactMap { $0 }
                    .flatMap({ $0 })
                onSuccess(combined)
            } catch {
                onError?(error)
            }
        }

        SearchManager.task?.resume()
    }
}

struct ResponseResultDTO: Codable {
    let albums: RootResponseDTO?
    let artists: RootResponseDTO?
    let tracks: RootResponseDTO?
}

struct RootResponseDTO: Codable {
    let items: [SearchResultDTO]
}

struct SearchResultDTO: Codable {
    let name: String
    let type: typeDTO
    let id: String
    let popularity: Int?
    let images: [ImageResultDTO]?
    let artists: [ArtistDTO]?
    let album: AlbumDTO?
}

struct ArtistDTO: Codable {
    let name: String
}

struct ImageResultDTO: Codable, Comparable {
    let height: Int
    let width: Int
    let url: URL?

    static func < (lhs: ImageResultDTO, rhs: ImageResultDTO) -> Bool {
        lhs.height < rhs.height
    }
}

struct AlbumDTO: Codable {
    let name: String
    let images: [ImageResultDTO]?
}

enum typeDTO: String, Codable {
    case track
    case album
    case artist
}
