//
//  APODContentView.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 30/04/2026.
//

import SwiftUI

extension APODDayView {
    
    struct APODContentView: View {
        let apod: APOD
        let cachedImageData: Data?
        
        var body: some View {
            VStack {
                Text(apod.title)
                    .font(.title2)
                    .bold()
                mediaView
                    .frame(height: 300)
                Text(apod.explanation)
                    .font(.body)
            }
            .foregroundStyle(.primary)
            .background(Color(.systemBackground))
        }
        
        @ViewBuilder var mediaView: some View {
            let url = apod.url
            let type = apod.mediaType
            
            switch type {
            case .image:
                if let data = cachedImageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView()
                }
            case .video:
                WebVideoView(url: url)
            case .unknown:
                Text("Unknown Media Type")
            }
        }
    }
}
