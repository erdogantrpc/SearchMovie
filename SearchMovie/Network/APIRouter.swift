//
//  APIRouter.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 14.07.2023.
//

import Foundation
import Alamofire

enum ApiRouter : APIConfiguration {
    case getMovies(query: String)
    case getMovieDetail(imdbId: String)
}

extension ApiRouter {
    var path: String {
        switch self {
        case .getMovies:
            return ""
        case .getMovieDetail:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMovies,
             .getMovieDetail:
            return .get
            
        }
    }
    
    var parameters: Parameters?{
        switch self {
        case .getMovies(let query):
            return ["s": query]
        case .getMovieDetail(imdbId: let imdbId):
            return ["i": imdbId]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Configuration.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        //Get query parameters
        var queryItems = [URLQueryItem]()
        
        //APikey
        let apikeyParameter = URLQueryItem(name: "apikey", value: AppConstants.apiKey)
        queryItems.append(apikeyParameter)
        
        // Parameters
        if method == .get  {
            if let parameters = parameters {
                for key in parameters.keys {
                    let queryParameter = URLQueryItem(name: key, value: parameters[key] as? String)
                    queryItems.append(queryParameter)
                }
            }
        } else {
            if let parameters = parameters {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
        }
        //add queryItems to urlRequest
        var urlComps = URLComponents(string: urlRequest.url!.absoluteString)!
        urlComps.queryItems = queryItems
        urlRequest.url = urlComps.url
        
        debugPrint("Request:::\(urlRequest.url?.absoluteString ?? "")")
        
        return urlRequest
    }
    
}
