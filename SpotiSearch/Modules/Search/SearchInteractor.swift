//
//  SearchInteractor.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

protocol SearchInteractorProtocol: class {

    func getToken(withRefreshToken refreshToken: String)
}

class SearchInteractor {

    let tokenManager: TokenManager
    let searchManager: SearchManager
    let presenter: SearchPresenterProtocol
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
}
