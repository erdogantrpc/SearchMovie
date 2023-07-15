//
//  ViewController.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 14.07.2023.
//

import UIKit
import Lottie

class SearchMovieViewController: UIViewController {
    
    private struct Constants {
        //TODO: Error Enum
        static let searchAnimation: String = "searchAnimation"
        static let viewControllerTitle: String =  "Search Movie"
        static let searchBarPlaceholder: String = "Search a fantastic movie"
        static let error: String = "Error"
    }
    
    private var timer: Timer?
    private let viewModel: SearchMovieViewModel = SearchMovieViewModel()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = Constants.searchBarPlaceholder
        searchBar.layer.borderWidth = 0
        searchBar.returnKeyType = .done
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let searchAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: Constants.searchAnimation)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.clipsToBounds = true
        animationView.isHidden = true
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupHideKeyboardGestureWhenTappedAround()
        viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }
    
    private func setupUI() {
        title = Constants.viewControllerTitle
        view.backgroundColor = .white
        view.addSubview(containerStackView)
        view.addSubview(searchAnimationView)
        containerStackView.addArrangedSubview(searchBar)
        containerStackView.addArrangedSubview(tableView)
        containerStackView.addArrangedSubview(UIView())
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            searchAnimationView.heightAnchor.constraint(equalToConstant: 150),
            searchAnimationView.widthAnchor.constraint(equalToConstant: 150),
            searchAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func toggleAnimation(showAnimation: Bool) {
        tableView.isHidden = showAnimation
        searchAnimationView.isHidden = !showAnimation
        showAnimation ? searchAnimationView.play() : searchAnimationView.stop()
    }
}

extension SearchMovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self else { return }
            Task {
                self.toggleAnimation(showAnimation: true)
                self.viewModel.searchMovies(query: searchText)
            }
        }
    }
}

extension SearchMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as? MovieTableViewCell {
            cell.selectionStyle = .none
            cell.configure(movie: viewModel.movies[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

extension SearchMovieViewController: SearchMovieViewModelDelegate {
    func didFetchMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.toggleAnimation(showAnimation: false)
        }
    }
    
    func presentError(with message: String) {
        self.toggleAnimation(showAnimation: false)
        showAlert(title: Constants.error, message: message)
    }
}
