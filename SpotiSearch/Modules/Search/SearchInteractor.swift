//
//  SearchInteractor.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

protocol SearchInteractorProtocol: class {

    func getToken(withRefreshToken refreshToken: String)
    func makeSearch(_ search: String, oftype types: [SearchItemType])
}

class SearchInteractor {

    let tokenManager: TokenManager
    let searchManager: SearchManager
    let presenter: SearchPresenterProtocol
    var searchItems = [SearchItem]()
    var token: Token?

    init(tokenManager: TokenManager,
         searchManager: SearchManager,
         presenter: SearchPresenterProtocol,
         token: Token? = nil) {
        self.tokenManager = tokenManager
        self.searchManager = searchManager
        self.presenter = presenter
        self.token = token
    }
}

extension SearchInteractor: SearchInteractorProtocol {

    func getToken(withRefreshToken refreshToken: String) {
        self.tokenManager.refreshToken(token: refreshToken) { tokenDTO in
            self.token = Token(tokenDTO: tokenDTO)
        } onError: { error in
            //Handle errors
        }
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