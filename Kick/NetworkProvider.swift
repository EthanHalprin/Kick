//
//  NetworkProvider.swift
//  Kick
//
//  Created by Ethan on 13/06/2020.
//  Copyright © 2020 Ethan Halprin©. All rights reserved.
//

import Foundation
import Combine

enum RequestError: Error {
    case sessionError(error: Error)
}

class NetworkProvider<T: Decodable> {
    
    var urlString: String!

    required init(_ url: String) {
        urlString = url
    }
    
    var publisher: AnyPublisher<T, Error> {

        var request = URLRequest(url: URL(string: self.urlString)!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("98cbf1108e1549e4b131527590d65ac8", forHTTPHeaderField: "X-Auth-Token")

        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .mapError { error -> RequestError in
                return RequestError.sessionError(error: error)
            }
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
