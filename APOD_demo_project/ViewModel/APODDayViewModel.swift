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
    private var currentRequestDate: String?
    
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
        apod = nil
        errorMessage = nil
        cachedImageData = nil
        
        let date = date ?? Date()
        let dateString = date.toAPODString()
        currentRequestDate = dateString
        
        defer {
            if currentRequestDate == dateString {
                isLoading = false
            }
        }
        
        do {
            let result = try await api.fetchAPOD(for: date)
            
            guard currentRequestDate == dateString else {
                print("discard outdated response")
                return
            }
            
            apod = result
            cache.saveAPOD(result, for: dateString)
            
            if result.mediaType == .image {
                await loadAndSaveCachedImage(from: result.url, for: dateString)
            }
        
        } catch {
            
            guard currentRequestDate == dateString else {
                return
            }
            
            if let cached = cache.loadAPOD(for: dateString) {
                apod = cached
                
                if cached.mediaType == .image {
                    cachedImageData = cache.loadAPODImage(for: dateString)
                }
                print("Failed to load new APOD. Showing cached APOD")
            } else {
                apod = nil
                errorMessage = error.localizedDescription
            }
           
        }
    }
    
    private func loadAndSaveCachedImage(from url: URL, for dateString: String) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard currentRequestDate == dateString else {
                print("discard outdated image response")
                return
            }
            
            cachedImageData = data
            cache.saveAPODImage(data, for: dateString)
        } catch {
            print("Faile to load image data", error)
        }
        
    }
}

