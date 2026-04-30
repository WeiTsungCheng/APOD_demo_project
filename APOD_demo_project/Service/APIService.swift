//
//  APIService.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 25/04/2026.
//

import Foundation

let apiURL: String = "https://api.nasa.gov/planetary/apod"

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed
    case noAPIKey
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
        case .noAPIKey:
            return "API key is not provided."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

protocol APIServiceProtocol {
    func fetchAPOD(for date: Date?) async throws -> APOD
}

class APIService: APIServiceProtocol {
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func fetchAPOD(for date: Date?) async throws -> APOD {
        
        guard let apiKey = Secrets.NASAAPIKey else {
            throw NetworkError.noAPIKey
        }
        
        var components = URLComponents(string: apiURL)!
        
        var queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        if let date {
            let dateString = dateFormatter.string(from: date)
            queryItems.append(URLQueryItem(name: "date", value: dateString))
        }
        
        components.queryItems = queryItems

        guard let url = components.url else {
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




