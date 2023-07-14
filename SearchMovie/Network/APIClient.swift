//
//  APIClient.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 14.07.2023.
//

import Alamofire
import PromisedFuture

protocol MovieServiceProtocol {
    func getMovies(query: String) -> Future<MoviesSearch, AFError>
}

final class APIClient: MovieServiceProtocol {
    
    @discardableResult
    private func performRequest<T:Decodable>(route: APIConfiguration, decoder: JSONDecoder = JSONDecoder()) -> Future<T,AFError> {
        return Future(operation: { completion in
            AF.request(route).responseDecodable(decoder: decoder, completionHandler: { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        })
    }
    
    func getMovies(query: String) -> PromisedFuture.Future<MoviesSearch, Alamofire.AFError> {
        return performRequest(route: ApiRouter.getMovies(query: query))
    }
}
