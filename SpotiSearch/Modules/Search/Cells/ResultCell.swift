//
//  ResultCell.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var elementLabel: UILabel!
    @IBOutlet weak var descriptionsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    var isFavorite = false

    func configureCell(info: ResultCellModel) {
        self.resultImageView.load(url: info.imageURL)
        self.elementLabel.text = info.name
        self.descriptionsLabel.text = info.description
        self.isFavorite = info.isFavorite
        self.isFavorite ? self.setFavorite() : self.unsetFavorite()
    }

    private func setFavorite() {
        let imageConfig = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
        self.favoriteButton.tintColor = UIColor(red: 168 / 255, green: 59 / 255, blue: 94 / 255, alpha: 1)
        self.favoriteButton.setImage(image, for: .normal)
    }

    private func unsetFavorite() {
        let imageConfig = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
        self.favoriteButton.tintColor = UIColor(red: 100 / 255, green: 100 / 255, blue: 100 / 255, alpha: 1)
        self.favoriteButton.setImage(image, for: .normal)
    }

    @IBAction func favoriteButtonAction(_ sender: Any) {
        self.isFavorite.toggle()
        self.isFavorite ? self.setFavorite() : self.unsetFavorite()
    }
}
