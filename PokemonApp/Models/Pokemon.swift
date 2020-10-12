//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Artem Kutasevych on 10/3/20.
//

import Foundation

struct Type: Codable {
    var name: String
}

struct Types: Codable {
    var type: Type
}

struct Stat: Codable {
    var name: String
    var url: String
}

struct Stats: Codable {
    var base_stat: Int
    var effort: Int
    var stat: Stat
}

struct Sprites: Codable {
    var front_default: String?
    var front_shiny: String?
    var back_default: String?
    var back_shiny: String?


    public static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    var stringURLs: [String] {
        var urls = [String]()
        
        if let frontDefault = front_default {
            urls.append(frontDefault)
        }
        
        if let frontShiny = front_shiny {
            urls.append(frontShiny)
        }
        
        if let backDefault = back_default {
            urls.append(backDefault)
        }
        
        if let backShiny = back_shiny {
            urls.append(backShiny)
        }
        
        return urls
    }
}

struct Pokemon: Codable {
    var name: String
    var pictureUrls: Sprites
    var types: [Types]
    var stats: [Stats]
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case stats
        case types
        case id
        case pictureUrls = "sprites"
    }
}
