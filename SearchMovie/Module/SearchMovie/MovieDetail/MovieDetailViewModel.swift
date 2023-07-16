//
//  MovieDetailViewModel.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 16.07.2023.
//

import Foundation

protocol MovieDetailViewModelDelegate: AnyObject {
    func didFetchMovieDetails(with movieDetail: Movie)
    func presentError(with message: String)
}

class MovieDetailViewModel {
    weak var delegate: MovieDetailViewModelDelegate?
    var movieService: MovieServiceProtocol
    private let imdbId: String
    
    init(imdbId: String, movieService: MovieServiceProtocol = APIClient()) {
        self.imdbId = imdbId
        self.movieService = movieService
    }
    
    func getMovieDetails() {
        let movieDetailFuture = self.movieService.getMovieDetails(imdbId: imdbId)
        movieDetailFuture.execute { [weak self] movieDetailResponse in
            guard let self else { return }
            if let error = movieDetailResponse.error {
                self.delegate?.presentError(with: error)
                return
            }
            
            self.delegate?.didFetchMovieDetails(with: movieDetailResponse)
        } onFailure: { error in
            self.delegate?.presentError(with: error.localizedDescription)
        }
    }
}
