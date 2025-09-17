//
//  GuessTheFlag.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 06/09/25.
//

import SwiftUI

struct GuessTheFlag: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer: Int = Int.random(in: 0...2)
    @State private var score: Int = 0
    @State private var scoreTitle: String = ""
    @State private var isPresented: Bool = false
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 500)
            .ignoresSafeArea()
            VStack {
                VStack {
                    Text("Guess the Flag")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    Spacer()
                    
                    VStack {
                        VStack {
                            Text("Select the flag of")
                                .foregroundStyle(.primary)
                                .font(.headline.weight(.regular))
                            Text("\(countries[correctAnswer])")
                                .foregroundStyle(.primary)
                                .font(.title.weight(.semibold))
                        }
                        .padding(20)
                        
                        ForEach(0..<3) { number in
                            Button {
                                flagTapped(number)
                            } label: {
                                Image(countries[number])
                                    .clipShape(.capsule)
                                    .shadow(radius: 5)
                            }
                            .alert(scoreTitle, isPresented: $isPresented) {
                                Button("Continue") {
                                    askQuestion()
                                }
                            } message: {
                                Text("Your score is \(score)")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.primary)
                        .padding(20)
                        
                    }
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    .padding(.horizontal, 15)
                    Spacer()
                    
                    Text("Your Score is \(score) !")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    
                }
            }
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong !"
            score = 0
        }
        isPresented = true
        
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    GuessTheFlag()
}
