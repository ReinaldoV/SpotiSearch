//
//  FavoritesManager.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import Foundation

class FavoritesManager {

    let favoritesKey = "favoritesKey"

    func saveFavorites(favorites: [SearchItem]) {
        let defaults = UserDefaults.standard
        defaults.set(favorites, forKey: favoritesKey)
    }

    func loadFavorites() -> [SearchItem] {
        let defaults = UserDefaults.standard
        guard let favorites = defaults.object(forKey: favoritesKey) as? [SearchItem] else {
            return [SearchItem]()
        }
        return favorites
    }

    func deleteFavorites() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: favoritesKey)
    }
}
