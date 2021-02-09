//
//  SearchPresenter.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

protocol SearchPresenterProtocol: class {
    func logout()
    func refreshSearchTable(withItems items: [SearchItem])
    func getToken(withRefreshToken refreshToken: String)
    func updateToken(withToken token: Token)
    func numberOfRows() -> Int
    func modelFor(cellForRowAt indexPath: IndexPath) -> ResultCellModel
    func requestSearch(withSearchString searchString: String?, andType type: SearchTypeCell.CellType?)
    func addFavorites(itemOnIndex index: Int)
    func isFavorite(itemOnIndex index: IndexPath) -> Bool
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
            let isFavorite = self.interactor.isFavorite(itemID: searchItem.id)
            var description = ""
            if let artistName = searchItem.artist {
                description = "\(artistName) · \(searchItem.type.stringValue())"
            } else {
                description = searchItem.type.stringValue()
            }
            return ResultCellModel(id: searchItem.id,
                                   name: searchItem.name,
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

    func numberOfRows() -> Int {
        let numberOfRows = self.cellModels.count
        if numberOfRows == 0 {
            self.view?.addEmptySearchView()
        } else {
            self.view?.deleteEmptySearchView()
        }
        return numberOfRows
    }

    func modelFor(cellForRowAt indexPath: IndexPath) -> ResultCellModel {
        guard self.cellModels.count > indexPath.row else { return ResultCellModel(id: "",
                                                                                  name: "",
                                                                                  description: "",
                                                                                  isFavorite: false,
                                                                                  imageURL: nil) }
        return self.cellModels[indexPath.row]
    }

    func requestSearch(withSearchString searchString: String?, andType type: SearchTypeCell.CellType?) {
        var types = [SearchItemType]()
        switch type {
        case .Top:
            types = [.track, .artist, .album]
        case .Album:
            types = [.album]
        case .Artist:
            types = [.artist]
        case .Tracks:
            types = [.track]
        case .none:
            types = [.track, .artist, .album]
        }
        self.interactor.makeSearch(searchString, oftype: types)
    }

    func logout() {
        self.cellModels = [ResultCellModel]()
        self.interactor.logout()
        self.view?.reloadTable()
    }

    func addFavorites(itemOnIndex index: Int) {
        guard self.cellModels.count > index else { return }
        self.interactor.addFavoriteOrDelete(self.cellModels[index])
    }

    func isFavorite(itemOnIndex index: IndexPath) -> Bool {
        guard self.cellModels.count > index.row else { return false }
        return self.interactor.isFavorite(itemID: self.cellModels[index.row].id)
    }
}
