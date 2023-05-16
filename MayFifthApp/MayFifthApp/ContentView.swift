//
//  ContentView.swift
//  MayFifthApp
//
//  Created by mertcan YAMAN on 15.05.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Image(systemName: "globe")
                .resizable()
                .frame(width: 200, height: 200)
                .padding()
        }
        .padding()
        .cornerRadius(20) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 5)
        )
        .overlay(Text("asd")
            .frame(width: 100, height: 30)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 5)
            )
            .background(Color(red: 250/255, green: 237/255, blue: 205/255)), alignment: .topLeading)
        .overlay(Button {
            print("Edit button was tapped")
            } label: {
                Image(systemName: "plus")
            }
            .background(.blue)
            .cornerRadius(10), alignment: .bottomTrailing)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
