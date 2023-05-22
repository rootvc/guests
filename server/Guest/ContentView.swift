//
//  ContentView.swift
//  Guest
//
//  Created by Yasyf Mohamedali on 5/22/23.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    @Published var isStarted = false
    let ble = BLE()
}

struct ContentView: View {
    @StateObject var state = ContentViewModel()
    
    var body: some View {
        VStack {
            Button(state.isStarted ? "Stop" : "Start") {
                state.isStarted.toggle()
                state.ble.toggle()
            }
            if state.isStarted {
                Text("ID: `\(BLE.ID.name)`").textSelection(.enabled)
                Text("UUID: `\(BLE.ID.uuid)`").textSelection(.enabled)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
