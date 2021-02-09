//
//  FavoritesManager.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import Foundation

protocol FavoritesManagerProtocol {
    func saveFavorites(favorites: [SearchItem])
    func loadFavorites() -> [SearchItem]
    func deleteFavorites()
}

class FavoritesManager: FavoritesManagerProtocol {

    let favoritesKey = "favoritesKey"

    func saveFavorites(favorites: [SearchItem]) {
        let data = favorites.map { try? JSONEncoder().encode($0) }
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: self.favoritesKey)
    }

    func loadFavorites() -> [SearchItem] {
        let defaults = UserDefaults.standard
        guard let encodedData = defaults.array(forKey: self.favoritesKey) as? [Data] else {
            return [SearchItem]()
        }

        return encodedData.map { try! JSONDecoder().decode(SearchItem.self, from: $0) }
    }

    func deleteFavorites() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: favoritesKey)
    }
}
