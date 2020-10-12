//
//  ImageCollectionViewCell.swift
//  PokemonApp
//
//  Created by Artem Kutasevych on 10/6/20.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func configure() {
        image.layer.backgroundColor = UIColor.white.cgColor
        image.layer.cornerRadius = 20.0
        image.layer.borderWidth = 3.0
        image.layer.borderColor = UIColor.systemGray.cgColor
        image.layer.masksToBounds = true
    }
}
