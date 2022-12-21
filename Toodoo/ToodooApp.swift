//
//  ToodooApp.swift
//  Toodoo
//
//  Created by Nick Chen on 2022-12-19.
//

import SwiftUI

@main
struct ToodooApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(DataStore())
        }
    }
}
