//
//  WeSplit.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 06/09/25.
//

import SwiftUI

struct WeSplitView: View {
    @State private var checkAmount = 0.0
    @State private var tipPercentage = 10
    @State private var noOfPeople = 0
    @FocusState private var amountIsFocused: Bool
    let tipPercentages = [10, 15, 20, 25, 0]
    var totalPerPerson: Double {
        let peopleCount = Double(noOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: "INR"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("No of people", selection: $noOfPeople) {
                        ForEach(2..<100) { data in
                            Text("\(data) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                Section("How much tip do you want to leave?") {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("We Split")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                if amountIsFocused{
                    Button("Done") {
                        amountIsFocused.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    WeSplitView()
}

