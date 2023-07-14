//
//  Configuration.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 14.07.2023.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

struct Configuration {
    struct ProductionServer {
        static let baseURL =  "http://www.omdbapi.com/"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
