//
//  SplashScreenViewModel.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 15.07.2023.
//

import FirebaseRemoteConfig

protocol SplashScreenViewModelDelegate: AnyObject {
    func networkActive()
    func presentNetworkError()
    func didFetchRemoteConfig(title: String)
    func presentRemoteConfigError()
}

class SplashScreenViewModel {
    
    private struct Constants {
        static let remoteConfigKey: String = "title"
    }
    
    weak var delegate: SplashScreenViewModelDelegate?
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    func checkNetworkConnection() {
        NetworkManager.shared.startMonitoring { [weak self] isNetworkActive in
            if isNetworkActive {
                self?.delegate?.networkActive()
            } else {
                self?.delegate?.presentNetworkError()
            }
        }
    }
    
    func fetchRemoteConfigs() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
            guard let self else { return }
            if status == .success, error == nil {
                self.remoteConfig.activate { _, error in 
                    guard error == nil else {
                        self.delegate?.presentRemoteConfigError()
                        return
                    }
                    
                    if let title = self.remoteConfig.configValue(forKey: Constants.remoteConfigKey).stringValue {
                        self.delegate?.didFetchRemoteConfig(title: title)
                    }
                }
            } else {
                self.delegate?.presentRemoteConfigError()
            }
        }
    }
}
