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
    func isFavorite(_ searchItem: SearchItem) -> Bool
    func logout()
}

class SearchInteractor {

    let tokenManager: TokenManager
    let searchManager: SearchManager
    var searchItems = [SearchItem]()
    var token: Token?
    weak var presenter: SearchPresenterProtocol?

    init(tokenManager: TokenManager,
         searchManager: SearchManager,
         token: Token? = nil) {
        self.tokenManager = tokenManager
        self.searchManager = searchManager
        self.token = token
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

    func isFavorite(_ searchItem: SearchItem) -> Bool {
        return false //to be implemented
    }

    func logout() {
        self.searchItems = [SearchItem]()
        self.token = nil
    }
}
