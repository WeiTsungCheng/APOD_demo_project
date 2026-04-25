//
//  APIService.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 25/04/2026.
//

import Foundation

let apiKey: String = "bZJb4lEjENpe62UgpaMTSXGsiw9QqoXASqxUJcRj"

protocol APIServiceProtocol {
    func fetchAPOD() async throws -> APOD
}

class APIService: APIServiceProtocol {
    func fetchAPOD() async throws -> APOD {
        let url = URL(string:
                        "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(APOD.self, from: data)
    }
    
}

