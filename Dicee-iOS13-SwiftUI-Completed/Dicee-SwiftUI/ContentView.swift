//
//  ContentView.swift
//  Dicee-SwiftUI
//
//  Created by Kaia Gao on 10/27/2022.
//
/**
 1. How to use SwiftUI
 2. What is Protocal
 It works like Interface in JAVA
 The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements defined in the protocal.
 3. Delegate design pattern
 4. Closure
 
 */

import SwiftUI

struct ContentView: View {
    // @State: a property wrapper tracking variables to read and update their value automatically and rebuild the struct by SwiftUI, or the value of structures should be immutable
    // it works similar as the keyword "mutating" before functions
    @State var leftDiceNumber = 1
    @State var rightDiceNumber = 1
    
    var body: some View {
        // Stack subviews in z-axis
        ZStack {
            // Subview 1: background image
            Image("background") // select  background.jpg from Assets
                .resizable() // resize the image to fit its space
                .edgesIgnoringSafeArea(.all) // extend to full screen
            // Subview 2: virtically stacted subviews
            VStack {
                Image("diceeLogo")
                Spacer() // creates an adaptive view with no content that expands as much as it can
                HStack {
                    // Initiate Structure DiceView
                    DiceView(n: leftDiceNumber)
                    DiceView(n: rightDiceNumber)
                }
                .padding(.horizontal) //  add a specified amount of padding to one or more edges of the view
                Spacer()
                // create a button by providing an action and a label.
                Button(action: { // The action to perform when the user triggers the button.
                    // must to add 'self' keyword when it is inside a closure, to be explicit about where the property or method lives
                    // without the keyword 'self', it will set new variable in the closure instead of update value for the defined variable of the current strut
                    self.leftDiceNumber = Int.random(in: 1...6)
                    self.rightDiceNumber = Int.random(in: 1...6)
                }) { // label and its formats
                    Text("Roll")
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                .background(Color.red)
            }
        }
    }
}

// structure DiceVIew adopts protocol View
// Implement the required body computed property to provide the content for your custom view.

struct DiceView: View {
    
    let n: Int
    
    var body: some View {
        Image("dice\(n)")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

