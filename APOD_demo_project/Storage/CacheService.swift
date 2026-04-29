//
//  APODCacheProtocol.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 29/04/2026.
//

import Foundation

protocol CacheServiceProtocol {
    func saveAPOD(_ apod: APOD, for date: String)
    func loadAPOD(for date: String) -> APOD?
    
    func saveAPODImage(_ data: Data, for date: String)
    func loadAPODImage(for date: String) -> Data?
}

// Save APOD model in UserDefault
// Save APOD image in FileManager
class CacheService: CacheServiceProtocol {
    
    private let apodKey = "cached_apod_key"
    private let apodImageName = "cached_apod_image"
    
    private var cachedDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    private func imageFileURL(for date: String) -> URL {
        cachedDirectory.appendingPathComponent(apodImageName + date)
    }
    
    func saveAPOD(_ apod: APOD, for date: String) {
        do {
            let data = try JSONEncoder().encode(apod)
            UserDefaults.standard.set(data, forKey: apodKey + date)
            print("Success to save APOD", date)
        } catch {
            print("Failed to save APOD", error)
        }
    }
    
    func loadAPOD(for date: String) -> APOD? {
        guard let data = UserDefaults.standard.data(forKey: apodKey + date) else {
            return nil
        }
        
        do {
            let apod = try JSONDecoder().decode(APOD.self, from: data)
            print("Success to load APOD", date)
            return apod
        } catch {
            print("Failed to load APOD", error)
            return nil
        }
    }
    
    func saveAPODImage(_ data: Data, for date: String) {
        do {
            try data.write(to: imageFileURL(for: date))
            print("Save APOD Image Success")
        } catch {
            print("Save APOD Image Failed", error)
        }
    }
    
    func loadAPODImage(for date: String) -> Data? {
        do {
            let data = try Data(contentsOf: imageFileURL(for: date))
            print("Load APOD Image Success")
            return data
        } catch {
            print("Load APOD Image Failed")
            return nil
        }
    }
    
    
}
