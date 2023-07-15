//
//  SplashScreenViewController.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 15.07.2023.
//

import UIKit
import Lottie
import Network

class SplashScreenViewController: UIViewController {
    
    private struct Constants {
        static let splashAnimation: String = "splashAnimation"
        static let remoteConfigErrorTitle: String = "Remote Config Hatası"
        static let remoteConfigErrorMessage: String = "Remote Config çekilirken bir hata meydana geldi"
        static let internetConnectionErrorTitle: String = "İnternet Bağlantısı Bulunamadı"
        static let internetConnectionErrorMessage: String = """
                                                            Uygulamayı kullanabilmek için internete bağlı olmanız gerekir,
                                                            lütfen bağlantınızı kontrol ettikten sonra tekrar deneyiniz
                                                            """
    }
    
    private let viewModel: SplashScreenViewModel = SplashScreenViewModel()
    
    private let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: Constants.splashAnimation)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.clipsToBounds = true
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        return animationView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: AppConstants.titleFont,
                            size: AppConstants.titleFontSize)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        animationView.play()
        viewModel.delegate = self
        viewModel.checkNetworkConnection()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(animationView)
        view.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 250),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: animationView.centerXAnchor)
        ])
    }
}

extension SplashScreenViewController: SplashScreenViewModelDelegate {
    func networkActive() {
        viewModel.fetchRemoteConfigs()
    }
    
    func presentNetworkError() {
        showAlert(title: Constants.internetConnectionErrorTitle,
                  message: Constants.internetConnectionErrorMessage)
    }
    
    func didFetchRemoteConfig(title: String) {
        DispatchQueue.main.async {
            self.titleLabel.text = title
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.setRootNavigationController(SearchMovieViewController())
            NetworkMonitor.shared.stopMonitoring()
        }
    }
    
    func presentRemoteConfigError() {
        showAlert(title: Constants.remoteConfigErrorTitle,
                  message: Constants.remoteConfigErrorMessage)
    }
}
