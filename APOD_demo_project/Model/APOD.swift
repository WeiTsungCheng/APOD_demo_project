//
//  APOD.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 25/04/2026.
//
import Foundation

enum MediaType: Codable, Equatable {
    case image
    case video
    case unknown(String)
    
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        
        switch value {
        case "image":
            self = .image
        case "video":
            self = .video
        default:
            self = .unknown(value)
        }
    }
}

struct APOD: Codable, Identifiable {
    
    let date: String
    let title: String
    let explanation: String
    let url: URL
    let hdURL: URL?
    let mediaType: MediaType
    let copyright: String?
    let serviceVersion: String
    var id: String { date }
    
    enum CodingKeys: String, CodingKey {
        case date
        case title
        case explanation
        case url
        case hdURL = "hdurl"
        case mediaType = "media_type"
        case copyright
        case serviceVersion = "service_version"
    }
}
