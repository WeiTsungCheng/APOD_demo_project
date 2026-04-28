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
                if vm.isLoading {
                    ProgressView()
                    
                } else if vm.apod != nil {
                    contentView
                    
                } else if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                    
                } else {
                    Text("No APOD loaded")
                }
            }.task {
                //                await vm.loadAPOD(date: Date.fromAPODString("2021-10-10"))
                //                await vm.loadAPOD(date: Date().addingDays(-1))
                await vm.loadAPOD(date: Date())
            }
        }
    }
}

extension APODDayView {
    
    @ViewBuilder var mediaView: some View {
        if let apod = vm.apod {
            let url = apod.url
            let type = apod.mediaType
            
            if type == .image {
                AsyncImage(url: url) { phase in
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
                
            } else {
                WebVideoView(url: url)
            }
        }
    }
    
    @ViewBuilder var contentView: some View {
        if let apod = vm.apod {
            
            ScrollView {
                Text(apod.title)
                    .font(.title2)
                    .bold()
                
                mediaView
                    .frame(height: 300)
                
                Text(apod.explanation)
                    .font(.body)
                
                if let copyright = apod.copyright {
                    Text("@ \(copyright)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
        
    }
}

#Preview {
    APODDayView(api: APIService())
}
