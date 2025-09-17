//
//  ContentView.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 06/09/25.
//
import SwiftUI

struct HomeView: View {
    let items = ["WeSplit", "GuessTheFlag", "BetterRest", "WordScramble", "Animations", "iExpense", "Moonshot"]
    
    // MARK: - Destination resolver
    @ViewBuilder
    private func destination(for item: String) -> some View {
        switch item {
        case "WeSplit":
            WeSplitView()
        case "GuessTheFlag":
            GuessTheFlag()
        case "BetterRest":
            BetterRest()
        case "WordScramble":
            WordScramble()
        case "Animations":
            Animations()
        case "iExpense":
            iExpense()
        case "Moonshot":
            Moonshot()
        default:
            Text("Coming Soon 🚀")
        }
    }
    // Define 2 columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(destination: destination(for: item)) {
                            Text(item)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .font(.headline)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
    

}

#Preview {
    HomeView()
}
