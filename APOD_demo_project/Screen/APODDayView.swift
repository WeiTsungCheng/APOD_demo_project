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
                    ProgressView()
                }
                
            }.task {
                await vm.loadAPOD()
            }
        }
    }
}

#Preview {
    APODDayView(api: APIService())
}
