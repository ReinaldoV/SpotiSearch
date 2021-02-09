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
    func addFavoriteOrDelete(_ item: ResultCellModel)
}

class SearchInteractor {

    let tokenManager: TokenManagerProtocol
    let searchManager: SearchManagerProtocol
    let favoritesManager: FavoritesManagerProtocol
    var searchItems = [SearchItem]()
    var favoriteItems = [SearchItem]()
    var token: Token?
    weak var presenter: SearchPresenterProtocol?

    init(tokenManager: TokenManagerProtocol,
         searchManager: SearchManagerProtocol,
         favoritesManager: FavoritesManagerProtocol,
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
        guard let searchString = search, !searchString.isEmpty else {
            //Retrieve the favorites
            self.searchItems = [SearchItem]()
            self.presenter?.refreshSearchTable(withItems: self.favoriteItems)
            return
        }

        guard let validToken = self.token?.accessToken else { return }

        self.searchManager.search(searchString,
                                  for: types.map { SearchCategories(withSearchItemType: $0) },
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
        self.favoriteItems = [SearchItem]()
        self.favoritesManager.deleteFavorites()
    }

    func addFavoriteOrDelete(_ item: ResultCellModel) {
        if let favoriteItem = self.favoriteItems.first(where: { $0.id == item.id }) {
            //DeleteItem
            self.favoriteItems.removeAll(where: { favoriteItem.id == $0.id })
        } else if let searchItem = self.searchItems.first(where: { $0.id == item.id }) {
            //AddItem
            self.favoriteItems.append(searchItem)
        } else {
            return
        }
        self.favoritesManager.deleteFavorites()
        self.favoritesManager.saveFavorites(favorites: self.favoriteItems)

        if self.searchItems.isEmpty {
            self.presenter?.refreshSearchTable(withItems: self.favoriteItems)
        }
    }
}
