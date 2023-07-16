//
//  MovieDetailViewController.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 16.07.2023.
//

import UIKit
import Lottie
import Firebase
import AlamofireImage

class MovieDetailViewController: BaseViewController {
    
    private struct Constants {
        static let viewControllerTitle: String = "Movie Detail"
        static let analyticEventKey: String = "movie_detail"
        static let analyticParameterKey: String = "movie_title"
    }
    
    private let viewModel: MovieDetailViewModel
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addBlurredBackground(style: .regular)
        return imageView
    }()
    
    let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let informationsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: AppConstants.titleFont, size: AppConstants.titleFontSize)
        label.textColor = .white
        label.addShadowToText()
        label.numberOfLines = 0
        return label
    }()
    
    let movieDirectorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.addShadowToText()
        label.numberOfLines = 0
        return label
    }()
    
    let movieLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.addShadowToText()
        label.numberOfLines = 0
        return label
    }()
    
    let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.addShadowToText()
        label.numberOfLines = 0
        return label
    }()
    
    let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.addShadowToText()
        return label
    }()
    
    init(imdbId: String) {
        self.viewModel = MovieDetailViewModel(imdbId: imdbId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        viewModel.delegate = self
        toggleAnimation(showAnimation: true)
        viewModel.getMovieDetails()
    }
    
    private func setupUI() {
        title = Constants.viewControllerTitle
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        view.addSubview(moviePosterImageView)
        view.addSubview(informationsStackView)
        informationsStackView.addArrangedSubview(movieTitleLabel)
        informationsStackView.addArrangedSubview(movieRatingLabel)
        informationsStackView.addArrangedSubview(movieDirectorNameLabel)
        informationsStackView.addArrangedSubview(movieLanguageLabel)
        view.addSubview(movieDescriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            moviePosterImageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor,
                                                          constant: 24),
            moviePosterImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor,
                                                      constant: 150),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 250),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 150),
            
            informationsStackView.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 24),
            informationsStackView.topAnchor.constraint(equalTo: moviePosterImageView.topAnchor, constant: 16),
            informationsStackView.trailingAnchor.constraint(lessThanOrEqualTo: backgroundImageView.trailingAnchor, constant: -16),
            
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.leadingAnchor),
            movieDescriptionLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 24),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: informationsStackView.trailingAnchor),
            movieDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: backgroundImageView.bottomAnchor)
        ])
    }
}

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func didFetchMovieDetails(with movieDetail: Movie) {
        if let posterUrl = URL(string: movieDetail.poster ?? "") {
            backgroundImageView.af.setImage(withURL: posterUrl)
            
            moviePosterImageView.af.setImage(withURL: posterUrl,
                                             placeholderImage: UIImage(named: AppConstants.imageNotFound),
                                             filter: ScaledToSizeWithRoundedCornersFilter(size: CGSize(width: 150,
                                                                                                 height: 250),
                                                                                    radius: 20))
        }
        guard let title = movieDetail.title, let director = movieDetail.director, let language = movieDetail.language, let rating = movieDetail.ratings?[0].value else { return }
        movieTitleLabel.text = title
        movieDirectorNameLabel.text = "Director: \(director)"
        movieLanguageLabel.text = "Language: \(language)"
        movieRatingLabel.text = "Rating: \(rating)"
        movieDescriptionLabel.text = movieDetail.plot
        self.toggleAnimation(showAnimation: false)
        AnalyticManager.shared.trackAction(screenType:
                                            .movieDetail(trackType:
                                                    .movieInfo(movieData:
                                                            MovieData(title: movieDetail.title ?? "")
                                                    )
                                            )
        )
    }
    
    func presentError(with message: String) {
        showAlert(error: .custom(message: message))
    }
}
