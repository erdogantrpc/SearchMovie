//
//  ViewController.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 14.07.2023.
//

import UIKit

class SearchMovieViewController: UIViewController {
    var movies: [Search] = []
    var movieService: MovieServiceProtocol
    
    init(service: MovieServiceProtocol = APIClient()) {
        movieService = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchMovies()
    }
    
    func fetchMovies() {
        let movieFuture = self.movieService.getMovies(query: "blade")
        movieFuture.execute { [weak self] (movieResponse) in
            guard let self else { return }
            if let error = movieResponse.error {
                //Alert Message
            }
            guard let movies = movieResponse.search else { return }
            self.movies.append(contentsOf: movies)
            print(self.movies)
        } onFailure: { (error) in
            print(error)
        }
    }
}

