//
//  Navigation.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 20/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                NavigationLink("Select \(i)", value: i)
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
            }
        }
    }
}
struct Student: Hashable {
    var id = UUID()
    var name: String
    var age: Int
}
struct DetailView: View {
    let value: Int
    var body: some View {
        Text("I am \(value)")
    }
    init(value: Int) {
        self.value = value
        print("I am here \(value)")
    }
}


struct Navigation: View {
    @State private var path = [Int]()
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Show 32") {
                    path = [32]
                }
                Button("Show 64") {
                    path.append(64)
                }
                Button("Show 32 and 64") {
                    path = [32,64]
                }
            }
            .navigationDestination(for: Int.self) { selection in
                Text("I am \(selection)")
            }
        }
        
    }
}


struct ProgramaticNavigation: View {
    @State private var path = NavigationPath()
    
    var body : some View {
        NavigationStack {
            List {
                ForEach(0..<5) { i in
                    NavigationLink("Select Number: \(i)", value: i)
                }
                
                ForEach(0..<5) { i in
                    NavigationLink("Select String: \(i)", value: String(i))
                }
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected the number \(selection)")
            }
            .navigationDestination(for: String.self) { selection in
                Text("You selected the string \(selection)")
            }
            .toolbar {
                Button("Push 556") {
                    path.append(556)
                }
                
                Button("Push Hello") {
                    path.append("Hello")
                }
            }
        }
    }
}
struct NavitionDetailsView: View {
    var number: Int
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationLink("NavitionDetailsView", value: Int.random(in: 0..<1000))
            .navigationTitle("Details \(number)")
            .toolbar {
                Button("Pop to root") {
                    path = NavigationPath()
                }
            }
    }
}

struct NavitionView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            NavitionDetailsView(number: 0, path: $path)
                .navigationDestination(for: Int.self) { value in
                    NavitionDetailsView(number: value, path: $path)
                }
        }
    }
    
}

struct NavitionDetailsViewStore: View {
    var number: Int

    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
    }
}

struct NavitionViewStore: View {
    @State private var pathStore = PathStore()

     var body: some View {
         NavigationStack(path: $pathStore.path) {
             NavitionDetailsViewStore(number: 0)
                 .navigationDestination(for: Int.self) { i in
                     NavitionDetailsViewStore(number: i)
                 }
         }
     }
    
}


@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }

        // Still here? Start with an empty path.
        path = NavigationPath()
    }

    func save() {
        guard let representation = path.codable else { return }

        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}
struct customNavigationBar: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                Text("Row \(i)")
            }
            .navigationTitle("My title")
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(.blue, for: .automatic)
            .toolbarColorScheme(.dark, for: .automatic)
            .toolbar(.hidden, for: .automatic)
        }
    }
}
struct customNavigationBarPosition: View {
    var body: some View {
        NavigationStack {
            Text("I am toolBar")
                .toolbar {
                    ToolbarItemGroup(placement: .navigation) {
                        Button("One toolbar item") {
                            print("Something")
                        }
                        Button("Two toolbar item") {
                            print("Something")
                        }
                    }
                }
        }
    }
}

struct EditableNavigationBar: View {
    @State private var titleText = "Navigation Title"
    var body: some View {
        NavigationStack {
            Text("I am a editable toolbar")
                .navigationTitle($titleText)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
    
#Preview {
    Navigation()
}
#Preview {
    ContentView()
}

#Preview {
    ProgramaticNavigation()
}

#Preview {
    NavitionView()
}

#Preview {
    NavitionViewStore()
}
#Preview {
    customNavigationBar()
}
#Preview {
    customNavigationBarPosition()
}
#Preview {
    EditableNavigationBar()
}
