//
//  SearchInteractor.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import Foundation

protocol SearchInteractorProtocol: class {
    func getToken(withRefreshToken refreshToken: String)
    func updateToken(withToken token: Token)
    func makeSearch(_ search: String?, oftype types: [SearchItemType])
    func isFavorite(itemID: String) -> Bool
    func logout()
    func addFavorite(_ item: ResultCellModel)
}

class SearchInteractor {

    let tokenManager: TokenManager
    let searchManager: SearchManager
    let favoritesManager: FavoritesManager
    var searchItems = [SearchItem]()
    var favoriteItems = [SearchItem]()
    var token: Token?
    weak var presenter: SearchPresenterProtocol?

    init(tokenManager: TokenManager,
         searchManager: SearchManager,
         favoritesManager: FavoritesManager,
         token: Token? = nil) {
        self.tokenManager = tokenManager
        self.searchManager = searchManager
        self.favoritesManager = favoritesManager
        self.token = token
        self.favoriteItems = self.favoritesManager.loadFavorites()
    }
}

extension SearchInteractor: SearchInteractorProtocol {

    func getToken(withRefreshToken refreshToken: String) {
        self.tokenManager.refreshToken(token: refreshToken) { tokenDTO in
            self.token = Token(tokenDTO: tokenDTO)
            //update refreshToken on keychain
        } onError: { error in
            //Handle errors
        }
    }

    func updateToken(withToken token: Token) {
        self.token = token
    }

    func makeSearch(_ search: String?, oftype types: [SearchItemType]) {
        guard let validToken = self.token?.accessToken else { return }

        guard let searchString = search, !searchString.isEmpty else {
            //Retrieve the favorites
            return
        }

        self.searchManager.search(searchString,
                                  for: types.map { SearchManager.SearchCategories(withSearchItemType: $0) },
                                  withToken: validToken,
                                  onSuccess: { results in
                                      self.searchItems = results.map { SearchItem(withDTO: $0) }
                                      DispatchQueue.main.async {
                                          self.presenter?.refreshSearchTable(withItems: self.searchItems)
                                      }
                                  },
                                  onError: nil)
    }

    func isFavorite(itemID: String) -> Bool {
        return self.favoriteItems.contains(where: { $0.id == itemID })
    }

    func logout() {
        self.searchItems = [SearchItem]()
        self.token = nil
        self.favoritesManager.deleteFavorites()
    }

    func addFavorite(_ item: ResultCellModel) {
        guard let searchItem = self.searchItems.first(where: { $0.id == item.id }) else { return }
        self.favoriteItems.append(searchItem)
        self.favoritesManager.deleteFavorites()
        self.favoritesManager.saveFavorites(favorites: self.favoriteItems)
    }
}
