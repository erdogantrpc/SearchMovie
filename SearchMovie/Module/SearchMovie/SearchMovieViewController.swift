//
//  ViewController.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 14.07.2023.
//

import UIKit
import Lottie

class SearchMovieViewController: BaseViewController {
    
    private struct Constants {
        static let viewControllerTitle: String =  "Search Movie"
        static let searchBarPlaceholder: String = "Search a Fantastic Movie"
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
        tableView.allowsMultipleSelection = false
        return tableView
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
        containerStackView.addArrangedSubview(searchBar)
        containerStackView.addArrangedSubview(tableView)
        containerStackView.addArrangedSubview(UIView())
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
                self.toggleAnimation(showAnimation: true, view: self.tableView)
                self.viewModel.searchMovies(query: searchText)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let imdbId = viewModel.movies[indexPath.row].imdbID else { return }
        navigationController?.pushViewController(MovieDetailViewController(imdbId: imdbId), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

extension SearchMovieViewController: SearchMovieViewModelDelegate {
    func didFetchComplete() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            self.toggleAnimation(showAnimation: false, view: self.tableView)
        }
    }
    
    func presentError(with message: String) {
        self.toggleAnimation(showAnimation: false, view: tableView)
        showAlert(error: .custom(message: message))
    }
}
