//
//  PokemonViewModel.swift
//  PokemonApp
//
//  Created by Artem Kutasevych on 10/3/20.
//

import UIKit

protocol  PokemonListViewModelDelegate: AnyObject {
    func updateUI()
    func showPokemonInformation(pokemon: Pokemon)
}

protocol PokemonListViewModelProtocol {
    var filteredModel: [PokemonListItem] { get }
    var networkAPI: Networkable { get }
    func pokemonDidSelect(name: String)
    func showOfficialImage(id: Int, completion: @escaping (UIImage?) -> ())
    func searchElements(searchText: String)
}

class PokemonListViewModel: PokemonListViewModelProtocol {
    
    private var model = [PokemonListItem]()
    weak var delegate: PokemonListViewModelDelegate?
    let networkAPI: Networkable
    private (set) var filteredModel = [PokemonListItem]()
    
    init(networkAPI: Networkable) {
        self.networkAPI = networkAPI
        self.getPokemons()
    }
    
    private func getPokemons() {
        networkAPI.getPokemons() { [weak self] pockemonsList in
            self?.model = pockemonsList
            self?.filteredModel = pockemonsList
            self?.delegate?.updateUI()
        }
    }
    
    func pokemonDidSelect(name: String) {
        networkAPI.getPokemon(name: name) { [weak self] pokemon in
            self?.delegate?.showPokemonInformation(pokemon: pokemon)
        }
    }
    
    func showOfficialImage(id: Int, completion: @escaping (UIImage?) -> ()) {
        networkAPI.getOfficialArtworkImage(id: id) { [weak self] image in
            if let image = image {
                completion(image)
            } else {
                self?.networkAPI.getPokemon(name: String(id)) { [weak self] pokemon in
                    if !pokemon.pictureUrls.stringURLs.isEmpty {
                        self?.networkAPI.getImageUsingURL(pokemon.pictureUrls.stringURLs.first ?? "") { image in
                                completion(image)
                        }
                    }
                }
            }
        }
    }
    
    func searchElements(searchText: String) {
        if searchText.isEmpty {
            filteredModel = model
        } else {
            filteredModel = model.filter( { $0.name.range(of: searchText, options: .caseInsensitive) != nil }  )
        }
        delegate?.updateUI()
    }
}

extension PokemonListViewModel: CancelableTask {
    func cancelTaskBy(id: Int) {
        networkAPI.cancelTaskBy(id: id)
    }
}
