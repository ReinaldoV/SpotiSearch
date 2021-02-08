//
//  SearchViewController.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var resultsTableView: UITableView!
    let searchTypeCellIdentifier = "kSearchTypeCell"
    let resultCellIdentifier = "kResultCell"

    override func viewDidLoad() {
        self.setupCollectionView()
        self.setupSearchBar()
        self.setupTableView()
    }

    @IBAction func avatarButton(_ sender: Any) {
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
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //to implement
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //to implement
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let resultCell = tableView.dequeueReusableCell(withIdentifier: self.resultCellIdentifier,
                                                             for: indexPath) as? ResultCell else {
            return ResultCell()
        }
        let model = ResultCellModel(name: "Nombre Loco",
                                    description: "Album · Maluma",
                                    isFavorite: false,
                                    imageURL: nil)
        resultCell.configureCell(info: model)
        return resultCell
    }
}
