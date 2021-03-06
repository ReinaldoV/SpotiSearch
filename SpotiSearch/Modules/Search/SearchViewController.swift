//
//  SearchViewController.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

protocol SearchViewControllerProtocol: UIViewController {
    func recieveNewToken(_ token: Token)
    func getNewToken(withRefreshToken refreshToken: String)
    func reloadTable()
    func addEmptySearchView()
    func deleteEmptySearchView()
    func openAuthViewForNewToken()
}

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var resultsTableView: UITableView!
    let searchTypeCellIdentifier = "kSearchTypeCell"
    let resultCellIdentifier = "kResultCell"
    var presenter: SearchPresenterProtocol?
    var coordinator: AppCoordinatorProtocol?
    var firstLoad = true

    static func instantiate(presenter: SearchPresenterProtocol,
                            coordinator: AppCoordinatorProtocol) -> SearchViewController {
        let nib = UINib(nibName: "SearchViewController", bundle: nil)
        let viewController = nib.instantiate(withOwner: self, options: nil)[0] as? SearchViewController
        viewController?.presenter = presenter
        viewController?.coordinator = coordinator
        return viewController ?? SearchViewController()
    }

    override func viewDidLoad() {
        self.setupCollectionView()
        self.setupSearchBar()
        self.setupTableView()
        self.searchBar.delegate = self
        self.gestureRecognicerToHideKeyboard()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.firstLoad {
            let index = IndexPath(row: 0, section: 0)
            self.typeCollectionView.selectItem(at: index, animated: false, scrollPosition: .left)
            self.firstLoad = false
            self.search()
        }
    }

    @IBAction func avatarButton(_ sender: Any) {
        self.presenter?.logout()
        self.coordinator?.logout()
    }

    private func setupSearchBar() {
        // SearchBar text
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.white

        // SearchBar placeholder
        let labelInsideUISearchBar = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        labelInsideUISearchBar?.textColor = UIColor.white
    }

    private func setupCollectionView() {
        guard let collectionView = self.typeCollectionView else {
            return
        }
        let searchTypeCellNib = UINib(nibName: "SearchTypeCell", bundle: nil)
        collectionView.register(searchTypeCellNib,
                                forCellWithReuseIdentifier: searchTypeCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
            flowLayout.scrollDirection = .horizontal
        }
    }

    private func setupTableView() {
        guard let tableView = self.resultsTableView else {
            return
        }
        let resultCellNib = UINib(nibName: "ResultCell", bundle: nil)
        tableView.register(resultCellNib, forCellReuseIdentifier: self.resultCellIdentifier)
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
    }

    private func search() {
        let searchString = searchBar.text
        var type: SearchTypeCell.CellType?
        if let selectedCellIndex = self.typeCollectionView.visibleCells.firstIndex(where: { $0.isSelected }),
            SearchTypeCell.CellType.allCases.count > selectedCellIndex {
            type = SearchTypeCell.CellType.allCases[selectedCellIndex]
        }
        self.presenter?.requestSearch(withSearchString: searchString, andType: type)
    }

    private func gestureRecognicerToHideKeyboard() {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                       action: #selector(self.viewTapped(recognizer:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        singleTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTap)
        self.view.isUserInteractionEnabled = true
    }

    @objc private func viewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == .ended) {
            self.searchBar.resignFirstResponder()
        }
    }

    @objc func favoriteButtonTap(sender: UIButton) {
        let buttonTag = sender.tag
        self.presenter?.addFavorites(itemOnIndex: buttonTag)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.search()
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SearchTypeCell.CellType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let typeCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.searchTypeCellIdentifier,
                                                                for: indexPath) as? SearchTypeCell else {
            return SearchTypeCell()
        }

        typeCell.configureCell(type: SearchTypeCell.CellType.allCases[indexPath.row])
        return typeCell
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.numberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let resultCell = tableView.dequeueReusableCell(withIdentifier: self.resultCellIdentifier,
                                                             for: indexPath) as? ResultCell,
            let model = self.presenter?.modelFor(cellForRowAt: indexPath) else {
            return ResultCell()
        }
        resultCell.configureCell(info: model)
        resultCell.selectionStyle = .none
        resultCell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTap(sender:)), for: .touchUpInside)
        resultCell.favoriteButton.tag = indexPath.row
        return resultCell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: SearchViewControllerProtocol {
    func recieveNewToken(_ token: Token) {
        self.presenter?.updateToken(withToken: token)
    }

    func getNewToken(withRefreshToken refreshToken: String) {
        self.presenter?.getToken(withRefreshToken: refreshToken)
    }

    func reloadTable() {
        self.resultsTableView.reloadData()
        if !self.resultsTableView.visibleCells.isEmpty {
            self.resultsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }

    func addEmptySearchView() {
        if let emptyView = Bundle.main.loadNibNamed("EmptyTableView", owner: self, options: nil)?[0] as? UIView {
            self.resultsTableView.backgroundView = emptyView
        }
    }

    func deleteEmptySearchView() {
        self.resultsTableView.backgroundView = nil
    }

    func openAuthViewForNewToken() {
        self.coordinator?.logout()
    }
}
