//
//  RootView.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 06/09/25.
//
import SwiftUI

struct RootView: View {
    @StateObject var nav = AppNavigation()
    
    var body: some View {
        NavigationStack(path: $nav.path) {
            HomeView()
                .navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .weSplitView:
                        WeSplitView()
                    }
                }
        }
        .environmentObject(nav)
    }
}
enum Screen: Hashable {
    case weSplitView
}
