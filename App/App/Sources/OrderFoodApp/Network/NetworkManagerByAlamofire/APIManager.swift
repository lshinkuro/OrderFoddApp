//
//  NetworkManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 11/10/24.
//

import Foundation
//import Alamofire
//
//public final class APIManager {
//    
//    public static let shared = APIManager()
//    private init() {}
//    
//    enum APIError: Error {
//        case failedToCreateRequest
//        case failedToGetData
//        case requestTimedOut
//    }
//}
//    
//
//extension APIManager {
//    
//    func fetchRequest<T: Codable>(endpoint: Endpoint, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
//        AF.request(endpoint.urlString,
//                   method: endpoint.method(),
//                   parameters: endpoint.queryParams,
//                   encoding: endpoint.encoding,
//                   headers: endpoint.headers)
//        .validate()
//        .responseDecodable(of: T.self) { response in
//            switch response.result {
//            case .success(let item):
//                completion(.success(item))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
