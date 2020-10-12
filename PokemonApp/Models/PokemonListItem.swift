//
//  PokemonListItem.swift
//  PokemonApp
//
//  Created by Artem Kutasevych on 10/3/20.
//

import Foundation

struct Root: Codable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable {
    var name: String
    var url: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    var id: Int {
        let fileName = url
        let fileArray = fileName.components(separatedBy: "/")
        return Int(fileArray.suffix(2).first ?? "") ?? 0
    }
}
