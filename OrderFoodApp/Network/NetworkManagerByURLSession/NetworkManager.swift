//
//  NetworkManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/10/24.
//

import Foundation


class NetworkManager: NSObject, URLSessionDelegate {
    
    public static let shared = NetworkManager()
    private override init() {}
    
    func requestData(url: URL,
                     method: String = "GET",
                     headers: [String: String] = [:],
                     parameters: [String: Any]? = nil,
                     encoding: ParameterEncodingU = .json) async throws -> Data {
        
        var requestURL = url
        var request = URLRequest(url: url)
        
        request.httpMethod = method

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let parameters = parameters {
                  switch encoding {
                  case .json:
                      // JSON Encoding - add parameters to the request body
                      request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                  case .query:
                      // Query String Encoding - append parameters to the URL
                      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                      urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                      if let modifiedURL = urlComponents?.url {
                          requestURL = modifiedURL
                          request.url = requestURL
                      }
                  }
              }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
    
    func fetchRequest<T: Codable>(endpoint: EndpointAPI,
                                  expecting type: T.Type,
                                  completion: @escaping (Result<T, Error>) -> Void) {
        Task {
            do {
                if let url = URL(string: endpoint.urlString) {
                    let result = try await self.requestData(url: url,
                                                       method: endpoint.method().rawValue,
                                                       headers: endpoint.headers,
                                                       parameters: endpoint.parameters)
                    
                    print("Data berhasil di dapat: \(result)")
                    
                    // Decode JSON data menjadi struct PlaceholderItem
                    let items = try JSONDecoder().decode(T.self, from: result)
                    completion(.success(items)) // Jika berhasil, kirim items melalui closure
                }
            } catch let error {
                completion(.failure(error)) // Jika terjadi error, kirim error melalui closure
            }
        }
    }
    
    
    // MARK: - URLSessionDelegate for SSL Pinning
        func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            guard let serverTrust = challenge.protectionSpace.serverTrust else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            
            // Load your local certificate
            if let certPath = Bundle.main.path(forResource: "google", ofType: "cer"),
               let certData = try? Data(contentsOf: URL(fileURLWithPath: certPath)),
               let certificate = SecCertificateCreateWithData(nil, certData as CFData) {
                
                // Compare the server certificate with the local certificate
                let serverCert = SecTrustCopyCertificateChain(serverTrust)
                let serverCertData = SecCertificateCopyData(serverCert! as! SecCertificate) as Data
                
                if certData == serverCertData {
                    let credential = URLCredential(trust: serverTrust)
                    completionHandler(.useCredential, credential)
                    return
                }
            }
            
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    
}
