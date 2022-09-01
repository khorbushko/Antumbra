//
//  ContentView.swift
//  CodeViewer
//
//  Created by phucld on 8/20/20.
//  Copyright © 2020 Dwarves Foundattion. All rights reserved.
//

import SwiftUI
import CodeViewer

struct ContentView: View {
    @State private var json = """
        {
            "hello": "world"
        }
        """
    
    var body: some View {
        VStack {
            CodeViewer(
                content: $json,
                mode: .json,
                darkTheme: .dawn,
                lightTheme: .solarized_light,
                fontSize: 13
            ) { text in
                print("new text: \(text)")
            }
            .onAppear {
              json = """
        {
            "hello": "world2 \(Int.random(in: 0...99999))"
        }
        """
            }
            
            Button(action: { print(json)} ) {
                Label("Json", systemImage: "pencil")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
