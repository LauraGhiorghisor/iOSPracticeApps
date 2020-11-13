//
//  ContentView.swift
//  Dicee-SwiftUI
//
//  Created by Laura Ghiorghisor on 16/06/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
   @State var leftDiceNo = 1
   @State var rightDiceNo = 6
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Image("diceeLogo")
                Spacer()
                HStack {
                    DiceView(n: leftDiceNo)
                    DiceView(n: rightDiceNo)
                }.padding(.horizontal)
                Spacer()
                Button(action: {
                    self.leftDiceNo = Int.random(in: 1...6)
                    self.rightDiceNo = Int.random(in: 1...6)
                }) {
                    Text("Roll")
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }.background(Color.red)
                Spacer()
            }
            
        }
    }
}


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
