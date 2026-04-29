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
    
    var canGoNextDate: Bool {
        if let date = selectedDate.addingDays(1) {
            return date <= Date()
        }
        return false
    }
    
    init(api: APIServiceProtocol, cache: CacheServiceProtocol) {
        _vm = State(wrappedValue: APODDayViewModel(api: api, cache: cache))
    }
    
    var body: some View {
        NavigationStack {
            
            Group {
                header
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                
                VStack(spacing: 0) {
                    
                    if vm.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                        
                    } else if vm.apod != nil {
                        ScrollView {
                            contentView
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
                
                footer
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
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

extension APODDayView {
    
    @ViewBuilder var mediaView: some View {
        if let apod = vm.apod {
            let url = apod.url
            let type = apod.mediaType
            
            switch type {
            case .image:
                if let data = vm.cachedImageData,
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
    
    var header: some View {
        
        HStack {
            Button {
                if let newDate = selectedDate.addingDays(-1) {
                    selectedDate = newDate
                }
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.accent)
            }
            
            DatePicker("Select Date",
                       selection: $selectedDate,
                       in: ...Date(),
                       displayedComponents: .date)
            .datePickerStyle(.automatic)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Button {
                if let newDate = selectedDate.addingDays(1),
                   // prevent user to load future no exist APOD info
                   newDate <= Date() {
                    selectedDate = newDate
                }
                
            } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.accent)
            }
            .disabled(!canGoNextDate)
            .opacity(canGoNextDate ? 1 : 0.3)
        }
    }
    
    @ViewBuilder var footer: some View {
        if let apod = vm.apod {
            HStack {
                Spacer()
                if let copyright = apod.copyright {
                    Text("@ \(copyright)")
                        .font(.caption)
                    Spacer()
                }
                
                Text("Version \(apod.serviceVersion)")
                    .font(.footnote)
                Spacer()
            }
            
        }
    }
    
    @ViewBuilder var contentView: some View {
        if let apod = vm.apod {
            Text(apod.title)
                .font(.title2)
                .bold()
            mediaView
                .frame(height: 300)
            Text(apod.explanation)
                .font(.body)
        }
    }
}

#Preview {
    APODDayView(api: APIService(), cache: CacheService())
}
