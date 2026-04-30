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
    
    private let cachedDateKey = "cached_date_key"
    private let apodKey = "cached_apod_key"
    private let apodImageName = "cached_apod_image"
    
    private var cachedDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    private var imageFileURL: URL {
        cachedDirectory.appendingPathComponent(apodImageName)
    }
    
    func saveAPOD(_ apod: APOD, for date: String) {
        do {
            let data = try JSONEncoder().encode(apod)
            UserDefaults.standard.set(data, forKey: apodKey)
            UserDefaults.standard.set(date, forKey: cachedDateKey)
            print("Success to save APOD", date)
        } catch {
            print("Failed to save APOD", error)
        }
    }
    
    func loadAPOD(for date: String) -> APOD? {
        guard UserDefaults.standard.string(forKey: cachedDateKey) == date else {
            print("No cached date", date)
            return nil
        }
        
        guard let data = UserDefaults.standard.data(forKey: apodKey) else {
            print("No cached APOD data", date)
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
        guard UserDefaults.standard.string(forKey: cachedDateKey) == date else {
            print("Not cached date for saving APOD Image", date)
            return
        }
        
        do {
            try data.write(to: imageFileURL)
            print("Save APOD Image Success", date)
        } catch {
            print("Save APOD Image Failed", error)
        }
    }
    
    func loadAPODImage(for date: String) -> Data? {
        guard UserDefaults.standard.string(forKey: cachedDateKey) == date else {
            print("Not cached date for loading APOD Image", date)
            return nil
        }
        
        do {
            let data = try Data(contentsOf: imageFileURL)
            print("Load APOD Image Success", date)
            return data
        } catch {
            print("Load APOD Image Failed", error)
            return nil
        }
    }
}
