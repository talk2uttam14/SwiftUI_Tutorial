//
//  Moonshot.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 17/09/25.
//

import SwiftUI


struct Moonshot: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    var body: some View {
        Text("Astronauts \(astronauts.count)")
            .font(.title)
    }
}




































struct MoonshotApp: View {
    var body: some View {
        ScrollView(.horizontal) { // for Horizonatal scrolling we need to have HStack inside ScrollView
            LazyHStack(spacing: 10) { // LazyHStack takes the all available space while HStack takes only the required space
                ForEach(0..<100) { item in
                    Text("Item \(item)")
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .scrollIndicators(.hidden)
    }
}
struct NavigationView: View {
    var body: some View {
        NavigationStack {
                List {
                    ForEach(0..<100) { item in
                        NavigationLink("Next \(item) Screen") {
                            Text("Screen \(item)")
                                .font(.title)
                        }
                    }
                }
        }
    }
}


struct User: Codable {
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}

struct JsonParser: View {
    var body: some View {
        Button("Decode JSON") {
            let input = """
            {
                "name": "Taylor Swift",
                "address": {
                    "street": "555, Taylor Swift Avenue",
                    "city": "Nashville"
                }
            }
            """
            let data = Data(input.utf8)
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                print(user.address.street)
            }
            

            // more code to come
        }
    }
}
struct GridView: View {
    var body : some View {
        let columns = [
            GridItem(.adaptive(minimum: 80, maximum: 120))
        ]
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0..<1000) { item in
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 80, height: 80)
                        .padding(20)
                }
            }
        }
    }
}

#Preview {
    Moonshot()
}
#Preview {
    NavigationView()
}
#Preview {
    JsonParser()
}
#Preview {
    MoonshotApp()
}
#Preview {
    GridView()
}
