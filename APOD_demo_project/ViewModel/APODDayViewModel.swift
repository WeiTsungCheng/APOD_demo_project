//
//  APODViewModel.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 25/04/2026.
//

import Foundation

@Observable
@MainActor
final class APODDayViewModel {
    var apod: APOD?
    var isLoading: Bool = false
    var errorMessage: String?
    private let api: APIServiceProtocol
    
    init(apod: APOD? = nil, isLoading: Bool = false, errorMessage: String? = nil, api: APIServiceProtocol) {
        self.apod = apod
        self.isLoading = isLoading
        self.errorMessage = errorMessage
        self.api = api
    }
    
    func loadAPOD(date: Date? = nil) async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            apod  = try await api.fetchAPOD(for: date)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}

