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
    var cellModels = [ResultCellModel]()

    init(interactor: SearchInteractorProtocol) {
        self.interactor = interactor
    }

    private func createViewModel(with items: [SearchItem]) -> [ResultCellModel] {
        return items.map { searchItem -> ResultCellModel in
            let isFavorite = self.interactor.isFavorite(searchItem)
            var description = ""
            if let artistName = searchItem.artist {
                description = "\(artistName) · \(searchItem.type.stringValue())"
            } else {
                description = searchItem.type.stringValue()
            }
            return ResultCellModel(name: searchItem.name,
                                   description: description,
                                   isFavorite: isFavorite,
                                   imageURL: searchItem.imageURL)
        }
    }
}

extension SearchPresenter: SearchPresenterProtocol {
    func refreshSearchTable(withItems items: [SearchItem]) {
        let orderedItemsByPopularity = items.sorted { $0.popularity > $1.popularity }
        self.cellModels = self.createViewModel(with: orderedItemsByPopularity)
        self.view?.reloadTable()
    }

    func getToken(withRefreshToken refreshToken: String) {
        self.interactor.getToken(withRefreshToken: refreshToken)
    }

    func updateToken(withToken token: Token) {
        self.interactor.updateToken(withToken: token)
    }
}
