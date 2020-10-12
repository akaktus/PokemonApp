//
//  PokemonListViewModelTest.swift
//  PokemonAppTests
//
//  Created by Artem Kutasevych on 10/6/20.
//

import XCTest
@testable import PokemonApp

class MockPokemonListViewModelDelegate: PokemonListViewModelDelegate {
    var immidiatelyExecuted: ((Pokemon) -> ())?
    
    func updateUI() {
        
    }
    
    func showPokemonInformation(pokemon: Pokemon) {
        immidiatelyExecuted?(pokemon)
    }
}


class PokemonListViewModelTest: XCTestCase {
    
    var sut: PokemonListViewModel?
    var delegate: MockPokemonListViewModelDelegate?

    override func setUpWithError() throws {
        let networkAPI = MockNetworkLayer()
        sut = PokemonListViewModel(networkAPI: networkAPI)
        delegate = MockPokemonListViewModelDelegate()
        sut?.delegate = delegate
    }

    override func tearDownWithError() throws {
        sut = nil
        delegate = nil
    }

    func testPokemonDidSelect() throws {
        
        let name = "testName"
        
        delegate?.immidiatelyExecuted = { pokemon in
            XCTAssert(pokemon.name == name)
        }
        
        sut?.pokemonDidSelect(name: name)
    }
}
