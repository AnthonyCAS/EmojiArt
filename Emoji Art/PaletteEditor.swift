//
//  PaletteEditor.swift
//  Emoji Art
//
//  Created by zhira on 7/30/24.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette

    @State private var emojisToAdd: String = ""

    private let emojiFont: Font = .system(size: 40)

    enum Focused {
        case name
        case addEmojis
    }

    @FocusState private var focused: Focused?

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("name", text: $palette.name)
                    .focused($focused, equals: .name)
            }
            Section(header: Text("Emojis")) {
                TextField("Add Emojis Here", text: $emojisToAdd)
                    .focused($focused, equals: .addEmojis)
                    .font(emojiFont)
                    .onChange(of: emojisToAdd) {
                        palette.emojis = (emojisToAdd + palette.emojis)
                            .filter { $0.isEmoji }
                            .uniqued
                    }
                removeEmojis
            }
        }
        .frame(minWidth: 300, minHeight: 350)
        .onAppear {
            if palette.name.isEmpty {
                focused = .name
            } else {
                focused = .addEmojis
            }
        }
    }

    private var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap to Remove Emojis")
                .font(.caption)
                .foregroundColor(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(palette.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.remove(emoji.first!)
                                emojisToAdd.remove(emoji.first!)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
}

#Preview {
    @State var palette = Palette(name: "Vehicles", emojis: "🚘")
    return PaletteEditor(palette: $palette)
}
