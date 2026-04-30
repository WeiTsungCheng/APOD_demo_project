//
//  APODDayFooterView.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 30/04/2026.
//

import SwiftUI

extension APODDayView {
    
    struct APODDayFooterView: View {
        let apod: APOD
        
        var body: some View {
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
            .padding(.top, 8)
            .foregroundStyle(.secondary)
            .background(Color(.secondarySystemBackground))
        }
    }
}
