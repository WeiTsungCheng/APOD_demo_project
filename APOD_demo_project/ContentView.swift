//
//  ContentView.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 25/04/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        APODDayView(api: APIService())
    }
}

#Preview {
    ContentView()
}
