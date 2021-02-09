//
//  SearchPresenter.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

protocol SearchPresenterProtocol: class {
    func refreshSearchTable(withItems items: [SearchItem])
    func getToken(withRefreshToken refreshToken: String)
    func updateToken(withToken token: Token)
}

class SearchPresenter {

    weak var view: SearchViewControllerProtocol?
    let interactor: SearchInteractorProtocol

    init(interactor: SearchInteractorProtocol) {
        self.interactor = interactor
    }

}

extension SearchPresenter: SearchPresenterProtocol {
    func refreshSearchTable(withItems items: [SearchItem]) {
        let orderedItemsByPopularity = items.sorted { $0.popularity > $1.popularity }

    }

    func getToken(withRefreshToken refreshToken: String) {
        self.interactor.getToken(withRefreshToken: refreshToken)
    }

    func updateToken(withToken token: Token) {
        self.interactor.updateToken(withToken: token)
    }
}
