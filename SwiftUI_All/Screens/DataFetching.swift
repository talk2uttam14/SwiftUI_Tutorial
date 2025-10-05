//
//  DataFetching.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 24/09/25.
//

import SwiftUI

struct Response: Codable {
    let results: [Result]
}
struct Result : Codable {
    let trackId: Int
    let trackName: String
    let collectionName: String
}


struct DataFetching: View {
    @State private var results = [Result]()
    var body: some View {
        NavigationStack {
            ScrollView {
                AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"),scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                } placeholder: {
                    ProgressView()
                }
                
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(results, id: \.trackId) { result in
                        VStack(alignment: .leading) {
                            Text(result.trackName)
                                .font(.headline)
                            Text(result.collectionName)
                                .font(.subheadline)
                        }
                        .padding(5)
                        Divider()
                    }
                }
                .task {
                    await loadData()
                }
                .toolbar(content: {
                    NavigationLink("Encode") {
                        EncodeWithCodingKeys()
                    }
                })
                .navigationTitle("Decode JSON")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Something went wrong")
        }
    }
}

@Observable
class UserData: Codable {
    var name = "Taylor"
    
    enum CodingKeys: String, CodingKey {
        case _name = "name"
    }//if we dont write enum {"_$observationRegistrar":{},"_name":"Taylor"}
}
struct EncodeWithCodingKeys : View {
    var body: some View {
         Button("Encode Taylor", action: encodeTaylor)
     }

     func encodeTaylor() {
         let data = try! JSONEncoder().encode(UserData())
         let str = String(decoding: data, as: UTF8.self)
         print(str)//{"_$observationRegistrar":{},"_name":"Taylor"}
     }
}

#Preview {
    DataFetching()
}
#Preview {
    EncodeWithCodingKeys()
}
