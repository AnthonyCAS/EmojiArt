//
//  PaletteStore.swift
//  Emoji Art
//
//  Created by zhira on 7/26/24.
//

import SwiftUI

extension UserDefaults {
    func palettes(forKey key: String) -> [Palette] {
        if let jsonData = data(forKey: key),
           let decodedPalettes = try? JSONDecoder().decode([Palette].self, from: jsonData)
        {
            return decodedPalettes
        }
        return []
    }
    
    func set(_ palettes: [Palette], forKey key: String) {
        let data = try? JSONEncoder().encode(palettes)
        set(data, forKey: key)
    }
}

class PaletteStore: ObservableObject, Identifiable {
    let name: String
    
    private var userDefaultKey: String {
        "PaletteStore:\(name)"
    }
    
    var id: String {
        name
    }
    
    var palettes: [Palette] {
        get {
            UserDefaults.standard.palettes(forKey: userDefaultKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultKey)
                objectWillChange.send()
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
        if palettes.isEmpty {
            palettes = Palette.builtins
            if palettes.isEmpty {
                palettes = [Palette(name: "Warning", emojis: "⚠️")]
            }
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
            palettes.replaceSubrange(insertionIndex ... insertionIndex, with: [palette])
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
    
    func removeAtCurrentCursorIndex() {
        palettes.remove(at: cursorIndex)
    }
}

extension PaletteStore: Hashable {
    static func == (lhs: PaletteStore, rhs: PaletteStore) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
