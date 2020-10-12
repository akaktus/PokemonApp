//
//  PokemonInformationViewModel.swift
//  PokemonApp
//
//  Created by Artem Kutasevych on 10/3/20.
//

import UIKit

protocol PokemonListInformationViewModelProtocol {
    var model: Pokemon { get }
    func getPictureFrom(urlString: String, completion: @escaping (UIImage?) -> ())
}

class PokemonInformationViewModel: PokemonListInformationViewModelProtocol {
    
    private(set) var model: Pokemon
    private let networkAPI: Networkable
    
    init(model: Pokemon, networkAPI: Networkable) {
        self.model = model
        self.networkAPI = networkAPI
    }
    
    func getPictureFrom(urlString: String, completion: @escaping (UIImage?) -> ()) {
        networkAPI.getImageUsingURL(urlString, completion: completion)
    }
}
