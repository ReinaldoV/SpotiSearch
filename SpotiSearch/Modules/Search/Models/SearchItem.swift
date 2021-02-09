//
//  SearchItem.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import Foundation

struct SearchItem {

    let name: String
    let type: SearchItemType
    let id: String
    let popularity: Int
    let imageURL: URL?
    let artist: String?
    let album: String?

    init(name: String,
         type: SearchItemType,
         id: String,
         popularity: Int,
         imageURL: URL?,
         artist: String,
         album: String) {
        self.name = name
        self.type = type
        self.id = id
        self.popularity = popularity
        self.imageURL = imageURL
        self.artist = artist
        self.album = album
    }

    init(withDTO dto: SearchResultDTO) {
        self.name = dto.name
        self.type = SearchItemType(withDTO: dto.type)
        self.id = dto.id
        self.popularity = dto.popularity ?? 0
        self.artist = dto.artist?.first?.name
        self.album = dto.album?.name
        if let images = dto.images {
            self.imageURL = images.min()?.url
        } else if let album = dto.album, let albumImages = album.images {
            self.imageURL = albumImages.min()?.url
        } else {
            self.imageURL = nil
        }
    }
}

enum SearchItemType {
    case track
    case album
    case artist

    init(withDTO dto: typeDTO) {
        switch dto {
        case .album:
            self = .album
        case .artist:
            self = .artist
        case .track:
            self = .track
        }
    }

    func stringValue() -> String {
        switch self {
        case .album:
            return "Album"
        case .track:
            return "Track"
        case .artist:
            return "Artirst"
        }
    }
}
