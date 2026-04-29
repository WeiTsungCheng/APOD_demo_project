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
    var cachedImageData: Data?
    
    private let api: APIServiceProtocol
    private let cache: CacheServiceProtocol
    
    init(apod: APOD? = nil, isLoading: Bool = false, errorMessage: String? = nil, api: APIServiceProtocol, cache: CacheServiceProtocol) {
        self.apod = apod
        self.isLoading = isLoading
        self.errorMessage = errorMessage
        self.api = api
        self.cache = cache
    }
    
    func loadAPOD(date: Date? = nil) async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let result = try await api.fetchAPOD(for: date)
            apod = result
            cache.saveAPOD(result)
            
            if result.mediaType == .image {
                await loadAndSaveCachedImage(from: result.url)
            }
        
        } catch {
            if let cached = cache.loadAPOD() {
                apod = cached
                
                if cached.mediaType == .image {
                    cachedImageData = cache.loadAPODImage()
                }
                print("Failed to load new APOD. Showing cached APOD")
            } else {
                apod = nil
                errorMessage = error.localizedDescription
            }
           
        }
    }
    
    private func loadAndSaveCachedImage(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            cachedImageData = data
            cache.saveAPODImage(data)
        } catch {
            print("Faile to load image data", error)
        }
        
    }
    
    
    
}

