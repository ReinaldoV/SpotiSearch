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
    let searchTypeCellIdentifier = "kSearchTypeCell"

    override func viewDidLoad() {
        self.setupCollectionView()
    }

    @IBAction func avatarButton(_ sender: Any) {
    }

    private func setupCollectionView() {
        guard let collectionView = self.typeCollectionView else {
            return
        }
        let searchTypeCellNib = UINib(nibName: "SearchTypeCell",
                                      bundle: nil)
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
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //to implement
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let typeCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.searchTypeCellIdentifier,
                                                                for: indexPath) as? SearchTypeCell else {
            return SearchTypeCell()
        }

        typeCell.configureCell(type: .Top)
        return typeCell
    }
}
