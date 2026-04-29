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
    
    init(api: APIServiceProtocol) {
        _vm = State(wrappedValue: APODDayViewModel(api: api))
    }
    
    var body: some View {
        NavigationStack {
            
            Group {
                header
                
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
        }
    }
    
    @ViewBuilder var footer: some View {
        if let apod = vm.apod {
            if let copyright = apod.copyright {
                Text("@ \(copyright)")
                    .font(.caption)
            }
            
            Text("Version \(apod.serviceVersion)")
                .font(.footnote)
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
    APODDayView(api: APIService())
}
