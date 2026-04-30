//
//  SecretsDecoder.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 30/04/2026.
//

import Foundation

enum Secrets {
    static var NASAAPIKey: String? {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "NASA_API_KEY") as? String, !key.isEmpty else {
                return nil
            }
            return key
        }
}
