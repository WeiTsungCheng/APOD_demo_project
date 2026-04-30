//
//  APODDayView.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 25/04/2026.
//

import SwiftUI

struct APODDayView: View {
    
    @State var vm: APODDayViewModel
    @State var selectedDate: Date = Date()
    var cachedImageData: Data?
    
    init(api: APIServiceProtocol, cache: CacheServiceProtocol) {
        _vm = State(wrappedValue: APODDayViewModel(api: api, cache: cache))
    }
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                APODDayHeaderView(selectedDate: $selectedDate)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                
                VStack(spacing: 0) {
                    
                    if vm.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                        
                    } else if let apod = vm.apod {
                        ScrollView {
                            APODContentView(apod: apod, cachedImageData: vm.cachedImageData)
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        
                    } else if vm.errorMessage != nil{
                        Spacer()
                        Text("No content on this date")
                        Spacer()
                        
                    } else {
                        Spacer()
                        Text("No APOD loaded")
                        Spacer()
                    }
                }
                
                if let apod = vm.apod {
                    APODDayFooterView(apod: apod)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                }
               
            }
            .task {
                await vm.loadAPOD(date: selectedDate)
            }
            .onChange(of: selectedDate) { _, newDate in
                Task {
                    await vm.loadAPOD(date: newDate)
                }
            }
        }
    }
}

#Preview {
    APODDayView(api: APIService(), cache: CacheService())
}
