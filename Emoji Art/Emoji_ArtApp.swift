//
//  Emoji_ArtApp.swift
//  Emoji Art
//
//  Created by zhira on 7/23/24.
//

import SwiftUI

@main
struct Emoji_ArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    
    @StateObject var paletteStore = PaletteStore(name: "Main")
    @StateObject var paletteStore2 = PaletteStore(name: "Alternate")
    @StateObject var paletteStore3 = PaletteStore(name: "Special")

    var body: some Scene {
        WindowGroup {
            PaletteManager(stores: [paletteStore, paletteStore2, paletteStore3])
//            EmojiArtDocumentView(document: defaultDocument)
//                .environmentObject(paletteStore)
        }
    }
}
