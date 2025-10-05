//
//  CupCakeCorner.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 25/09/25.
//

import SwiftUI

struct CupCakeCorner: View {
    @State private var order = Order()
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Selct your cupcake type", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) { index in
                            Text(Order.types[index])
                        }
                    }
                    Stepper("Select no of cupcakes \(order.quantity)", value: $order.quantity, in: 3...20)
                        .sensoryFeedback(.increase, trigger: order.quantity)
                }
                Section {
                    Toggle("Any special request?", isOn: $order.specialRequestEnabled.animation())
                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkle", isOn: $order.addSprinkles)
                    }
                }
                Section {
                    NavigationLink("Delivery details") {
                        AddressDetails(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}
struct AddressDetails: View {
    @Bindable var order: Order
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Pin code", text: $order.pinCode)
            }
            Section {
                NavigationLink("Check out") {
                    CheckOutView(order: order)
                }
                .disabled(!order.hasValidAddress)
            }
        }
        .navigationTitle("Address Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct CheckOutView: View {
    var order: Order
    @State var showinConfirmation: Bool = false
    @State var confirmationMessage: String = ""
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),scale: 3) {
                image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 233)
            } placeholder: {
                ProgressView()
            }
            Text("Your total is \(order.cost, format: .currency(code: "INR"))")
                .font(.title)
            Button("Place Order", action: {
                Task {
                    await placeOrder()
                }
            })
                        .padding()
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank Yoy ...!", isPresented: $showinConfirmation) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
    }
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else { return print("Enable to fetch data") }
        dump(encoded)
        guard let url = URL(string: "https://reqres.in/api/cupcakes") else {
            print("Invalid URL")
            return  }
        if let jsonString = String(data: encoded, encoding: .utf8) {
                    print("Encoded JSON:\n\(jsonString)")
                }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
 
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            }
            confirmationMessage = "Your order for \(order.quantity)x \(Order.types[order.type].lowercased()) cupcakes is on its way!"
            showinConfirmation = true
        } catch {
            print("Upload failed: \(error.localizedDescription)")
        }
    }
 
}

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _pinCode = "pinCode"
        case _hasValidAddress = "hasValidAddress"
        case _cost = "cost"
    }
        
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    var type = 0
    var quantity = 3
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    var name = ""
    var streetAddress = ""
    var city = ""
    var pinCode = ""
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || pinCode.isEmpty {
            return false
        }
        return true
    }
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        cost += Decimal(type) / 2
        if extraFrosting {
            cost += Decimal(quantity)
        }
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        return cost
    }
    init() {} 
    
    // MARK: - Codable
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            type = try container.decode(Int.self, forKey: ._type)
            quantity = try container.decode(Int.self, forKey: ._quantity)
            specialRequestEnabled = try container.decode(Bool.self, forKey: ._specialRequestEnabled)
            extraFrosting = try container.decode(Bool.self, forKey: ._extraFrosting)
            addSprinkles = try container.decode(Bool.self, forKey: ._addSprinkles)
            name = try container.decode(String.self, forKey: ._name)
            streetAddress = try container.decode(String.self, forKey: ._streetAddress)
            city = try container.decode(String.self, forKey: ._city)
            pinCode = try container.decode(String.self, forKey: ._pinCode)
            // we don’t decode hasValidAddress or cost, because they are computed
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: ._type)
            try container.encode(quantity, forKey: ._quantity)
            try container.encode(specialRequestEnabled, forKey: ._specialRequestEnabled)
            try container.encode(extraFrosting, forKey: ._extraFrosting)
            try container.encode(addSprinkles, forKey: ._addSprinkles)
            try container.encode(name, forKey: ._name)
            try container.encode(streetAddress, forKey: ._streetAddress)
            try container.encode(city, forKey: ._city)
            try container.encode(pinCode, forKey: ._pinCode)
            // encode computed values too
            try container.encode(hasValidAddress, forKey: ._hasValidAddress)
            try container.encode(cost, forKey: ._cost)
        }
}



#Preview {
    CupCakeCorner()
}
