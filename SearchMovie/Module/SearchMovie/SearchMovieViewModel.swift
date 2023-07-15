//
//  SearchMovieViewModel.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 15.07.2023.
//

import Foundation

protocol SearchMovieViewModelDelegate: AnyObject {
    func didFetchMovies()
    func presentError(with message: String)
}

class SearchMovieViewModel {
    weak var delegate: SearchMovieViewModelDelegate?
    var movies: [MovieSearch] = []
    var movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = APIClient()) {
        self.movieService = movieService
    }
    
    func searchMovies(query: String) {
        guard !query.isEmpty else {
            self.movies = []
            delegate?.didFetchMovies()
            return
        }
        
        let movieFuture = self.movieService.getMovies(query: query)
        movieFuture.execute { [weak self] (movieResponse) in
            guard let self else { return }
            if let error = movieResponse.error {
                self.delegate?.presentError(with: error)
                return
            }
            guard let movies = movieResponse.search else { return }
            self.movies = movies
            self.delegate?.didFetchMovies()
        } onFailure: { (error) in
            self.delegate?.presentError(with: "Bekleyenmeyen hata")
        }
    }
}
