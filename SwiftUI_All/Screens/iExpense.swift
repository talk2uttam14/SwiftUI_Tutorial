//
//  iExpense.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 14/09/25.
//

import SwiftUI



struct ExpenceItem: Identifiable, Codable {
    // here it conforms to identifiable protocol so that we can use it in ForEach loop also we can skip id property while creating object like  ForEach(expenses.item) {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenceItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenceItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct iExpense: View {
    @State private var expenses = Expenses()
    @State private var showAddView = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items,id: \.id) {
                    item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                EditButton()
                Button("Add item", systemImage: "plus") {
                    showAddView.toggle()
                }
            }
            .sheet(isPresented: $showAddView) {
                AddView(expenses: expenses)
            }
        }
    }
    func removeItems(at offset: IndexSet) {
        expenses.items.remove(atOffsets: offset)
    }
}

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var type: String = "Personal"
    @State private var amount: Double = 0.0
    var expenses: Expenses
    let types = ["Business", "Personal"]
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) { item in
                        Text(item)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "INR"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let expenseItem = ExpenceItem(name: name, type: type, amount: amount)
                    expenses.items.append(expenseItem)
                    dismiss()
                }
            }
        }
    }
    
}





struct FirstView: View {
    @State private var showingSecondView = false
    var body: some View {
        Button {
            showingSecondView.toggle()
        } label: {
            Text("Go to Second View")
        }
        .sheet(isPresented: $showingSecondView) {
            SecondView()
        }
    }
}
struct SecondView: View {
    @Environment(\.dismiss) var dismiss // Environment variable dismiss to go back
    var body: some View {
        Button {
            dismiss()
        } label: {
            Text("Go Back")
        }
        
    }
}
struct iExpenseInitial: View {
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    @State private var showAppStorage: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(numbers, id:\.self) {
                        numbers in
                        Text("Row \(numbers)")
                    }
                    .onDelete { indexSet in
                        deleteRow(at: indexSet)
                    }
                    // On delete only availabe in Foreach
                }
                VStack(spacing: 40) {
                    Button("Add Number") {
                        numbers.append(currentNumber)
                        currentNumber += 1
                    }
                    Button("App Storage") {
                        showAppStorage.toggle()
                    }
                }
                
                
            }
            .toolbar {
                EditButton()
                // This button automatically adds the edit mode to the list and you can delete rows
            }
            .sheet(isPresented: $showAppStorage) {
                StoreData()
            }
        }
    }
    func deleteRow(at offset: IndexSet) {
        numbers.remove(atOffsets: offset)
    }
    
}
struct StoreData: View {
    //    @State private var tapcount = UserDefaults.standard.integer(forKey: "Tap")
    @AppStorage("Tap")  var tapcount = 0
    //MARK: - it does the same thing like auser defaults but more easier for integer and boolean but cant handle complex data types
    var body: some View {
        Button("Tap count: \(tapcount)") {
            tapcount += 1
            //            UserDefaults.standard.set(tapcount, forKey: "Tap")
        }
    }
}

#Preview {
    iExpense()
    //    FirstView()
    //    iExpenseInitial()
    //    StoreData()
}
