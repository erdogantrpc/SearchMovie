//
//  MoviesSearch.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 14.07.2023.
//

import Foundation

struct MoviesSearch: Codable {
    let search: [Search]?
    let totalResults, response, error: String?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
}

// MARK: - Search
struct Search: Codable {
    let title, year, imdbID, type, poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
