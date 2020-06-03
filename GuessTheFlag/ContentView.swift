//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dathan Wong on 5/27/20.
//  Copyright © 2020 Dathan Wong. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State private var rotation = 0.0
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30){
                VStack{
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0 ..< 3){
                    number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        if(number == self.correctAnswer){
                            FlagImage(number: number, countries: self.countries)
                            .rotation3DEffect(.degrees(self.rotation), axis: (x: 0, y: 1, z: 0))
                        }else{
                            FlagImage(number: number, countries: self.countries)
                                .opacity(self.opacity)
                                .transition(.slide)
                                .animation(.easeOut)
                        }
                    }
                }
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")){
                self.opacity = 1.0
                self.askQuestion()
                })
        }
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            score += 1
            scoreTitle = "Correct"
            withAnimation(){
                rotation += 360
                opacity = 0.25
            }
        } else{
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: View{
    let number: Int
    let countries: [String]
    
    var body: some View{
        Image(self.countries[self.number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
