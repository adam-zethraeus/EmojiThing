//
//  EmojiThingApp.swift
//  Shared
//
//  Created by Adam Zethraeus on 2021-05-05.
//

import SwiftUI

@main
struct EmojiThingApp: App {
    let xmlTest = AnnotationsReader()
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear{
                let trie = xmlTest.trie()
                let jsonData = try! JSONEncoder().encode(trie)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                print(jsonString)
                let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    .first!
                    .appendingPathComponent("trie.json")
                print(fileURL)
                try! jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
            }
        }
    }
}
