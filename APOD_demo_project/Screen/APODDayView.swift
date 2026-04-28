//
//  APODDayView.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 25/04/2026.
//

import SwiftUI

struct APODDayView: View {
    
    @State var vm: APODDayViewModel
    
    init(api: APIServiceProtocol) {
        _vm = State(wrappedValue: APODDayViewModel(api: api))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if let apod = vm.apod {
                    
                    if apod.mediaType == .image {
                        AsyncImage(url: apod.url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 200, height: 200)
                        
                    } else {
                        WebVideoView(url: apod.url)
                            .frame(height: 300)
                    }
                    
                } else {
                    ProgressView()
                }
                
            }.task {
//                await vm.loadAPOD(date: Date.fromAPODString("2021-10-10"))
//                await vm.loadAPOD(date: Date().addingDays(-1))
                await vm.loadAPOD(date: Date())
            }
        }
    }
}

#Preview {
    APODDayView(api: APIService())
}
