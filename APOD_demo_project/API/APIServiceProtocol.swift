//
//  APIServiceProtocol.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 30/04/2026.
//

import Foundation

protocol APIServiceProtocol {
    func fetchAPOD(for date: Date?) async throws -> APOD
}
