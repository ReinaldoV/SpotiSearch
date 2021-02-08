//
//  UIImageViewExtension.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

extension UIImageView {
    func load(url: URL?) {
        guard let urlNotOptional = url else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: urlNotOptional) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
