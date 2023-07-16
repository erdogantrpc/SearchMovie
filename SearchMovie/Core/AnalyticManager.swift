//
//  AnalyticManager.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 16.07.2023.
//

import FirebaseAnalytics

protocol EventProtocol {
    func trackAction(screenType: ScreenType)
}

enum ScreenType {
    case movieDetail(trackType: TrackType)
    
    var trackType: TrackType {
        switch self {
        case .movieDetail(trackType: let trackType):
            return trackType
        }
    }
    
    var eventName: String {
        switch self {
        case .movieDetail:
            return "movie_detail"
        }
    }
}

enum TrackType {
    case movieInfo(movieData: MovieData)
}

struct MovieData {
    let title: String
}

class AnalyticManager: EventProtocol {
    static let shared = AnalyticManager()
    
    func trackAction(screenType: ScreenType) {
        switch screenType.trackType {
        case .movieInfo(movieData: let movieData):
            Analytics.logEvent(screenType.eventName,
                               parameters: ["movie_title": movieData.title])
        }
    }
}
