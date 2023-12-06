//
//  APIMovie.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/5/22.
//

import Foundation

struct SearchResponse: Decodable {
    var movies: [APIMovie]
    
    enum CodingKeys: String, CodingKey {
        case moives = "Search"
    }
    
    init(movies: [APIMovie]) {
        self.movies = movies
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        movies = try container.decode([APIMovie].self, forKey: .moives)
    }
}

struct APIMovie: Identifiable, Hashable, Codable {
    let title: String
    let year: String
    let imdbID: String
    let posterURL: URL?
    
    var id: String { imdbID }

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case posterURL = "Poster"
    }

}

extension Movie {
    var posterURL: URL? {
        guard let posterURLString else { return URL(string: "") }
        return URL(string: posterURLString)
    }
}
