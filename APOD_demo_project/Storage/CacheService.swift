//
//  APODCacheProtocol.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 29/04/2026.
//

import Foundation

protocol CacheServiceProtocol {
    func saveAPOD(_ apod: APOD)
    func loadAPOD() -> APOD?
    
    func saveAPODImage(_ data: Data)
    func loadAPODImage() -> Data?
}

// Save APOD model in UserDefault
// Save APOD image in FileManager
class CacheService: CacheServiceProtocol {
    
    private let apodKey = "cached_apod_key"
    private let apodImageName = "cached_apod_image"
    
    private var cachedDirectory: URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    private var imageFileURL: URL? {
        cachedDirectory?.appendingPathComponent(apodImageName)
    }
    
    func saveAPOD(_ apod: APOD) {
        do {
            let data = try JSONEncoder().encode(apod)
            UserDefaults.standard.set(data, forKey: apodKey)
            print("Success to save APOD")
        } catch {
            print("Failed to save APOD", error)
        }
    }
    
    func loadAPOD() -> APOD? {
        guard let data = UserDefaults.standard.data(forKey: apodKey) else {
            return nil
        }
        
        do {
            let apod = try JSONDecoder().decode(APOD.self, from: data)
            print("Success to load APOD")
            return apod
        } catch {
            print("Failed to load APOD", error)
            return nil
        }
    }
    
    func saveAPODImage(_ data: Data) {
        if let url = imageFileURL {
            do {
                try data.write(to: url)
                print("Save APOD Image Success")
            } catch {
                print("Save APOD Image Failed")
            }
        }
    }
    
    func loadAPODImage() -> Data? {
        if let url = imageFileURL {
            do {
                let data = try Data(contentsOf: url)
                print("Load APOD Image Success")
                return data
            } catch {
                print("Load APOD Image Failed")
                return nil
            }
        }
        return nil
    }
    
    
}
