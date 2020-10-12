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
    var networkAPI: MockNetworkLayer?

    override func setUpWithError() throws {
        networkAPI = MockNetworkLayer()
        if let networkAPI = networkAPI {
            sut = PokemonListViewModel(networkAPI: networkAPI)
        }
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
    
    func testShowOfficialImage() {
        //given
        let id =  121
        
        //when
        sut?.showOfficialImage(id: id, completion: { image in
            //then
            XCTAssert(image?.accessibilityIdentifier == "officialImage")
            
        })
    }
    
    func testSearchElements() {
        //given
        let searchWord = "test"
        
        //when
        sut?.searchElements(searchText: searchWord)
        
        //then
        XCTAssert( ((sut?.filteredModel.first?.name.contains(searchWord)) != nil))
    }
    
    func testCancelTaskById() {
        //given
        let id = 14
        
        //when
        sut?.cancelTaskBy(id: id)
        
        // then
        XCTAssert(networkAPI?.id == id)
    }
}
