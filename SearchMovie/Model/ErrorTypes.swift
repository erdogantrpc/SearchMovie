//
//  ErrorTypes.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 16.07.2023.
//

import Foundation

enum ErrorTypes {
    case networkNotFound
    case remoteConfig
    case custom(message: String)
    
    var message: String {
        switch self {
        case .networkNotFound:
            return  """
                    You must be connected to the internet to use the application,
                    please check your internet connection
                    """
        case .remoteConfig:
            return "An error occurred while retrieving Remote Config"
        case .custom(message: let message):
            return message
        
        }
    }
}
