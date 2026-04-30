//
//  CacheServiceProtocol.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 30/04/2026.
//
import Foundation

protocol CacheServiceProtocol {
    func saveAPOD(_ apod: APOD, for date: String)
    func loadAPOD(for date: String) -> APOD?
    
    func saveAPODImage(_ data: Data, for date: String)
    func loadAPODImage(for date: String) -> Data?
}
