//
//  SearchPresenter.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

protocol SearchPresenterProtocol: class {
    func refreshSearchTable(withItems items: [SearchItem])
}

class SearchPresenter {

    let view: SearchViewControllerProtocol

    init(view: SearchViewControllerProtocol) {
        self.view = view
    }

}

extension SearchPresenter: SearchPresenterProtocol {
    func refreshSearchTable(withItems items: [SearchItem]) {
        let orderedItemsByPopularity = items.sorted { $0.popularity > $1.popularity }
        
    }
}
