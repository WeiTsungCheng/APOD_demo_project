//
//  APIService.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 25/04/2026.
//

import Foundation

let apiKey: String = "bZJb4lEjENpe62UgpaMTSXGsiw9QqoXASqxUJcRj"

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The server response is invalid."
        case .badStatusCode(let code):
            return "The server returned an error (\(code))."
        case .decodingFailed:
            return "Failed to decode the server response."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

protocol APIServiceProtocol {
    func fetchAPOD() async throws -> APOD
}

class APIService: APIServiceProtocol {
    func fetchAPOD() async throws -> APOD {
        let url = URL(string:
                        "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)")
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            let statusCode = httpResponse.statusCode
            guard 200..<300 ~= statusCode else {
                throw NetworkError.badStatusCode(statusCode)
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(APOD.self, from: data)
                
            } catch {
                throw NetworkError.decodingFailed
            }
            
        } catch let error as NetworkError {
            throw error
            
        } catch {
            throw NetworkError.unknown(error)
        }
        
    }
    
}

