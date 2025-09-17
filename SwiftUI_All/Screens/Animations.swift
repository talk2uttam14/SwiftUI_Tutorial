//
//  Animations.swift
//  SwiftUI_All
//
//  Created by UTTAM KUMAR DEY on 13/09/25.
//

import SwiftUI

struct Animations: View {
    @State private var animationAmount = 1.0
//    @State private var animationAmount = 0.0

    var body: some View {
        Button("Tap Me") {
            // animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .overlay(
            Circle()
                .stroke(.red)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeInOut(duration: 1)
                        .repeatForever(autoreverses: false),
                    value: animationAmount
                )
        )
        .onAppear {
            animationAmount = 2
        }
//        
//        Button("Tap Me") {
//            withAnimation(.spring(duration: 1, bounce: 0.5)) {
//                animationAmount += 360
//            }        }
//        .padding(50)
//        .background(.red)
//        .foregroundStyle(.white)
//        .clipShape(.circle)
//        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
//
    }
}
struct CustomAnimations: View {
    @State private var enabled = false

    var body: some View {
        Button("Tap Me") {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red)
        .animation(.default, value: enabled)
        .foregroundStyle(.white)
        .clipShape(.rect(cornerRadius: enabled ? 60 : 0))
        .animation(.spring(duration: 1, bounce: 0.6), value: enabled)
    }
}
struct DragCharacters: View {
    let letters = Array("Hello SwiftUI")
       @State private var enabled = false
       @State private var dragAmount = CGSize.zero

       var body: some View {
           HStack(spacing: 0) {
               ForEach(0..<letters.count, id: \.self) { num in
                   Text(String(letters[num]))
                       .padding(5)
                       .font(.title)
                       .background(enabled ? .blue : .red)
                       .offset(dragAmount)
                       .animation(.linear.delay(Double(num) / 20), value: dragAmount)
               }
           }
           .gesture(
               DragGesture()
                   .onChanged { dragAmount = $0.translation }
                   .onEnded { _ in
                       dragAmount = .zero
                       enabled.toggle()
                   }
           )
       }
}

struct Transition: View {
    @State private var isShowingRed = false

    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }

            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
//                    .transition(.scale)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))

            }
        }
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}
struct CustomModifier: View {
    @State private var isShowingRed = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)

            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

#Preview {
    CustomModifier()
    Transition()
    DragCharacters()
    CustomAnimations()
    Animations()
}
