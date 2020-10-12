//
//  NetworkLayer.swift
//  PokemonApp
//
//  Created by Artem Kutasevych on 10/3/20.
//

import UIKit

protocol Networkable {
    func getPokemons(completion: @escaping ([PokemonListItem]) -> () )
    func getPokemon(name: String, completion: @escaping (Pokemon) -> ())
    func getImageUsingURL(_ urlString: String, completion: @escaping (UIImage?) -> ())
    func getOfficialArtworkImage(id: Int, completion: @escaping (UIImage?) -> ())
    func cancelTaskBy(id: Int)
}


class NetworkLayer: Networkable {
    
    private let baseUrl = "https://pokeapi.co/api/v2/"
    private let session = URLSession.shared
    private let imageCache = NSCache<NSString, UIImage>()
    
    func getPokemons(completion: @escaping ([PokemonListItem]) -> ()) {
        guard let url = URL(string: "\(baseUrl)pokemon-species?limit=893") else {
            return
        }
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {
                do {
                     let decoder = JSONDecoder()
                     let response = try decoder.decode(Root.self, from: data)
                     let pokemonsList = response.results
                     completion(pokemonsList)
                } catch {
                    print(error)
                }
            }
            
            if let error = error {
                print(error)
            }
        })
        task.resume()
    }
    
    
    
    func getPokemon(name: String, completion: @escaping (Pokemon) -> ()) {
        
        guard let url = URL(string: "\(baseUrl)pokemon/\(name)") else {
            return
        }
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {
                do {
                     let decoder = JSONDecoder()
                     let response = try decoder.decode(Pokemon.self, from: data)
                     completion(response)
                } catch {
                    print(error)
                }
            }
            
            if let error = error {
                print(error)
            }
        })
        task.resume()
    }
    
    
    func getImageUsingURL(_ urlString: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            completion(imageFromCache)
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { [weak self] data, responce, error in
            if let data = data {
                if let image = UIImage(data: data) {
                    completion(image)
                    self?.imageCache.setObject(image, forKey: urlString as NSString)
                }
            }
            
            if let error = error {
                print(error)
            }
        })
        task.resume()
    }
    
    func getOfficialArtworkImage(id: Int, completion: @escaping (UIImage?) -> ()) {
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            completion(imageFromCache)
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { [weak self] data, responce, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
                self?.imageCache.setObject(image, forKey: urlString as NSString)
            } else {
                completion(nil)
            }
        })
        task.resume()
    }
    
    func cancelTaskBy(id: Int) {
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        guard let url = URL(string: urlString) else {
            return
        }
        
        session.getAllTasks { tasks in
            tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest?.url == url }.first?
                .cancel()
        }
    }
}
