//
//  MovieAPIController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

class MovieAPIController {
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        var urlComponents = URLComponents(string: "http://www.omdbapi.com/")!
        
        let APIKey = URLQueryItem(name: "apiKey", value: "dc92b96")
        let title = URLQueryItem(name: "s", value: searchTerm)
        
        urlComponents.queryItems = [APIKey, title]
        
        
        let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
        let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
        
        return searchResponse.movies
    }
}
