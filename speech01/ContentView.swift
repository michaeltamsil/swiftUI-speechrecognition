//
//  ContentView.swift
//  speech01
//
//  Created by michael tamsil on 30/09/20.
//

import SwiftUI

struct ContentView: View {
    //func speechRec.hasil = ""
    @ObservedObject var speechRec = SpeechRec()
    
    
    
    init() {
        speechRec.hasil = ""
        
        do {
            try speechRec.startRecording()
        } catch let error {
            print("Error : \(error)")
        }
    }
    
    var body: some View {
        VStack{
            Text(speechRec.hasil ?? "")
                .padding()
                .foregroundColor(.blue)
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
        }
        .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
