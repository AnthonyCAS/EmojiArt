//
//  PaletteChooser.swift
//  Emoji Art
//
//  Created by zhira on 7/26/24.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var store: PaletteStore

    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()
    }

    private var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            store.cursorIndex += 1
        }
        .contextMenu {
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "Math", emojis: "+−×÷∝∞")
            }
            AnimatedActionButton("delete", systemImage: "minus.circle", role: .destructive) {
                store.remove()
            }
        }
    }

    private func view(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
        .id(palette.id)
        .transition(.rollUp)
    }
}

struct ScrollingEmojis: View {
    let emojis: [String]

    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}
