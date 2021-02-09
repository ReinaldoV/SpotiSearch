//
//  SearchInteractor.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

protocol SearchInteractorProtocol: class {
    func getToken(withRefreshToken refreshToken: String)
    func updateToken(withToken token: Token)
    func makeSearch(_ search: String, oftype types: [SearchItemType])
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

    func makeSearch(_ search: String, oftype types: [SearchItemType]) {
        guard let validToken = self.token?.accessToken else { return }
        self.searchManager.search(search,
                                  for: types.map { SearchManager.SearchCategories(withSearchItemType: $0) },
                                  withToken: validToken,
                                  onSuccess: { results in
                                      self.searchItems = results.map { SearchItem(withDTO: $0) }
                                      //Call to Presenter and update the view on main thread
                                  },
                                  onError: nil)
    }
}
