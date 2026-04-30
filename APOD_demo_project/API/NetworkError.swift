//
//  NetworkError.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 30/04/2026.
//

import Foundation

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
