//
//  PaletteStore.swift
//  Emoji Art
//
//  Created by zhira on 7/26/24.
//

import SwiftUI

class PaletteStore: ObservableObject {
    private let name: String
    
    
    @Published private(set) var palettes: [Palette] {
        didSet {
            if palettes.isEmpty, !oldValue.isEmpty {
                palettes = oldValue
            }
        }
    }
    @Published private var _cursorIndex: Int = 0
    
    var cursorIndex: Int {
        get { boundsCheckedPaletteIndex(_cursorIndex) }
        set { _cursorIndex = boundsCheckedPaletteIndex(newValue) }
    }
    
    init(name: String) {
        self.name = name
        palettes = Palette.builtins
        if palettes.isEmpty {
            palettes = [Palette(name: "Warning", emojis: "⚠️")]
        }
    }
    
    private func boundsCheckedPaletteIndex(_ index: Int) -> Int {
        var index = index % palettes.count
        if index < 0 {
            index += palettes.count
        }
        return index
    }
    
    private func insert(palette: Palette, at insertionIndex: Int? = nil) {
        let insertionIndex = boundsCheckedPaletteIndex(insertionIndex ?? cursorIndex)
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            palettes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex)
            palettes.replaceSubrange(insertionIndex...insertionIndex, with: [palette])
        } else {
            palettes.insert(palette, at: insertionIndex)
        }
    }
    
    private func append(palette: Palette) {
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            if palettes.count == 1 {
                palettes = [palette]
            } else {
                palettes.remove(at: index)
                palettes.append(palette)
            }
        } else {
            palettes.append(palette)
        }
    }
    
    // MARK: - Intents
    
    func insert(name: String, emojis: String, at index: Int? = nil) {
        insert(palette: Palette(name: name, emojis: emojis), at: index)
    }
    
    func append(name: String, emojis: String) {
        append(palette: Palette(name: name, emojis: emojis))
    }
    
    func remove() {
        palettes.remove(at: cursorIndex)
    }
}
