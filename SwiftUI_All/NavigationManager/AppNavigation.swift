//
//  NavigationManager.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 06/09/25.
//
import SwiftUI

class AppNavigation: ObservableObject {
    @Published var path: [Screen] = []
    
    // For modal presentation
    @Published var showModal: Bool = false
    @Published var modalScreen: Screen? = nil
    
    func goHome() {
        path.removeAll()
    }
    
    func popToRoot() {
        path = []
    }
    
    func present(_ screen: Screen) {
        modalScreen = screen
        showModal = true
    }
    
    func dismiss() {
        showModal = false
        modalScreen = nil
    }
}


