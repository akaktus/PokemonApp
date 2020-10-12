//
//  PokemonListCollectionViewCell.swift
//  PokemonApp
//
//  Created by Artem Kutasevych on 10/9/20.
//

import UIKit

protocol CancelableTask: AnyObject {
    func cancelTaskBy(id: Int)
}

class PokemonListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var id = 0
    weak var delegate: CancelableTask?
    
    override func prepareForReuse() {
        imageView.image = nil
        delegate?.cancelTaskBy(id: self.id)
        activityIndicator.stopAnimating()
    }
    
    func configure(with pokemon: PokemonListItem?) {
        id = pokemon?.id ?? 0
        label.text = pokemon?.name
        label.font = UIFont.preferredFont(forTextStyle: .body)
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 5.0
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.masksToBounds = true
    }
}
