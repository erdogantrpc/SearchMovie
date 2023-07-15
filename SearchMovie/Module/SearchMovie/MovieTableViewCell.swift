//
//  MovieTableViewCell.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 15.07.2023.
//

import UIKit
import AlamofireImage

class MovieTableViewCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.font = UIFont(name: AppConstants.titleFont, size: AppConstants.titleFontSize)
        label.numberOfLines = 0
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(movieImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(yearLabel)
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            
            movieImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            movieImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            movieImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor, constant: -24),
            
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            yearLabel.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor, constant: 24),
            yearLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
    
    func configure(movie: MovieSearch) {
        //TODO: Placeholder image
        if let url = URL(string: movie.poster) {
            movieImageView.af.setImage(withURL: url,
                                       filter: ScaledToSizeWithRoundedCornersFilter(size: CGSize(width: 180,
                                                                                                 height: 200),
                                                                                    radius: 20))
        }
        titleLabel.text = movie.title
        yearLabel.text = movie.year
    }
}
