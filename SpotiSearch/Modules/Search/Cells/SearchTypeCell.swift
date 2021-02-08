//
//  SearchTypeCell.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

class SearchTypeCell: UICollectionViewCell {

    enum CellType: String {
        case Top
        case Tracks
        case Artist
        case Album
    }

    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var typeLabel: UILabel!

    func configureCell(type: CellType) {
        self.typeLabel.text = type.rawValue
    }

    override func layoutSubviews() {
        roundImageView()
    }

    private func roundImageView() {
        whiteBackgroundView.layer.cornerRadius = 15
    }
}
