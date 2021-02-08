//
//  SearchTypeCell.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

class SearchTypeCell: UICollectionViewCell {

    enum CellType: String, CaseIterable {
        case Top
        case Tracks
        case Artist
        case Album
    }

    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var typeLabel: UILabel!

    func configureCell(type: CellType, isSelected: Bool) {
        self.typeLabel.text = type.rawValue
        isSelected ? self.setSelected() : self.setUnnselected()
    }

    override func layoutSubviews() {
        roundImageView()
    }

    private func roundImageView() {
        whiteBackgroundView.layer.cornerRadius = 15
    }

    private func setSelected() {
        let whiteColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
        let darkGreyColor = UIColor(red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 1)
        self.whiteBackgroundView.backgroundColor = whiteColor
        self.typeLabel.backgroundColor = whiteColor
        self.typeLabel.textColor = darkGreyColor
    }

    private func setUnnselected() {
        self.whiteBackgroundView.backgroundColor = UIColor.clear
        self.whiteBackgroundView.layer.borderWidth = 1
        let whiteColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
        self.whiteBackgroundView.layer.borderColor = whiteColor.cgColor
        self.typeLabel.backgroundColor = UIColor.clear
        self.typeLabel.textColor = whiteColor
    }
}
