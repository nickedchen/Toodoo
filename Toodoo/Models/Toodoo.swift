//
//  Toodoo.swift
//  Toodoo
//
//  Created by Nick Chen on 2022-12-20.
//

import Foundation

struct ToDo: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var completed: Bool = false

    static var sampleData: [ToDo] {
        [
            ToDo(name: "Learn SwiftUI", completed: true),
            ToDo(name: "Build an app"),
            ToDo(name: "Publish to the App Store"),
        ]
    }
}
