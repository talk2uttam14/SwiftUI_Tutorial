//
//  Moonshot.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 17/09/25.
//

import SwiftUI


struct Moonshot: View {
    @State private var showingGrid = false
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    var body: some View {
        NavigationStack {
            Group {
                if showingGrid {
                    GridLayout(astronauts: astronauts, missions: missions)
                } else {
                    ListLayout(astronauts: astronauts, missions: missions)
                }
            }
            .toolbar(content: {
                Button("Some Button", systemImage: showingGrid ? "circle.grid.3x3.circle" : "list.bullet.circle") {
                    showingGrid.toggle()
                }
            })
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}
struct ListLayout: View {
    let rows = [
        GridItem(.flexible())
    ]
    var astronauts: [String: Astronaut]
    var missions: [Mission]
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: rows) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronaut: astronauts)
                        } label: {
                            HStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .frame(width: 100, height: 100)
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            }
                            .padding([.horizontal, .bottom])
                        }
                    }
                }
            }
        }
    }
}

struct GridLayout: View {
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    var astronauts: [String: Astronaut]
    var missions: [Mission]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronaut: astronauts)
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .frame(width: 100, height: 100)
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            }
                            .padding([.horizontal, .bottom])
                        }
                    }
                }
            }
        }
    }
    
}
struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                Text("Launch Date: \(mission.formattedLaunchDate)")
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundStyle(.gray)
                    .padding(.vertical)
                
                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    Text(mission.description)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundStyle(.gray)
                        .padding(.vertical)
                    
                    Text("Crew")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .padding(.bottom, 5)
                    
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(crew, id: \.role) { crew in
                        NavigationLink {
                            AstronautView(astronaut: crew.astronaut)
                        } label: {
                            HStack {
                                Image(crew.astronaut.id)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 104, height: 72)
                                    .clipShape(.circle)
                                    .overlay {
                                        Circle().strokeBorder(.white, lineWidth: 1)
                                    }
                                VStack(alignment: .leading) {
                                    Text(crew.astronaut.name)
                                        .foregroundStyle(.white)
                                        .font(.caption)
                                    Text(crew.role)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                            }
                        }
                    }
                }
            }
            
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
        
    }
    init(mission: Mission, astronaut: [String: Astronaut]) {
        self.mission = mission
        self.crew = mission.crew.map({ member in
            if let astronaut = astronaut[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        })
    }
}


struct AstronautView: View {
    let astronaut: Astronaut
    
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                Text(astronaut.description)
                    .font(.headline)
                    .padding()
            }
            
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct MoonshotApp: View {
    var body: some View {
        ScrollView(.horizontal) { // For Horizonatal scrolling we need to have HStack inside ScrollView
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
