//
//  PokemonInformationViewModelTest.swift
//  PokemonAppTests
//
//  Created by Artem Kutasevych on 10/6/20.
//

import XCTest
@testable import PokemonApp

class MockNetworkLayer: Networkable {
    func cancelTaskBy(id: Int) {
    
    }
    
    
    func getOfficialArtworkImage(id: Int, completion: @escaping (UIImage?) -> ()) {
        
    }
    
    func getPokemons(completion: @escaping ([PokemonListItem]) -> ()) {
        completion([PokemonListItem(name: "testPokemon", url: "testUrl")])
    }
    
    func getPokemon(name: String, completion: @escaping (Pokemon) -> ()) {
        completion(MockPokemon.pokemon)
    }
    
    func getImageUsingURL(_ urlString: String, completion: @escaping (UIImage?) -> ()) {
        let image = UIImage()
        image.accessibilityIdentifier = "testImage"
        completion(image)
    }
}

class MockPokemon {
    static let pokemon = Pokemon(name: "testName",
                                 pictureUrls: Sprites(front_default: "testFron", front_shiny: "testShiny", back_default: "backDefault", back_shiny: "backShiny"),
                                 types: [Types(type: Type(name: "testType"))],
                                 stats: [Stats(base_stat: 50, effort: 0, stat: Stat(name: "testName", url: ""))],
                                 id: 2)
}
    

class PokemonInformationViewModelTest: XCTestCase {
    
    var sut: PokemonInformationViewModel?

    override func setUpWithError() throws {
        let networkLayer = MockNetworkLayer()
        sut = PokemonInformationViewModel(model: MockPokemon.pokemon, networkAPI: networkLayer)
    }

    override func tearDownWithError() throws {
       sut = nil
    }

    func testGetPictureFromURL() throws {
        
        //given
        let urlString = sut?.model.pictureUrls.front_default ?? ""
        
        //when
        sut?.getPictureFrom(urlString: urlString, completion: { image in
            //then
            XCTAssert(image?.accessibilityIdentifier == "testImage")
            
        })
    }
}
