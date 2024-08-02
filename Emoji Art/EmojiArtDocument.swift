//
//  EmojiArtDocument.swift
//  Emoji Art
//
//  Created by zhira on 7/23/24.
//

import Foundation
import SwiftUI

class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
            autosave()
        }
    }
    
    private let autoSaveURL: URL = URL.documentsDirectory.appendingPathComponent("autosaved.emojiart")
    
    var background: URL? {
        emojiArt.background
    }
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    init() {
        if let data = try? Data(contentsOf: autoSaveURL),
           let autoSavedEmojiArt = try? EmojiArt(json: data)
        {
            emojiArt = autoSavedEmojiArt
        }
    }
    
    private func autosave() {
        save(to: autoSaveURL)
        print("autosaved to \(autoSaveURL)")
    }
    
    private func save(to url: URL) {
        do {
            let jsonData: Data = try emojiArt.json()
            try jsonData.write(to: url)
        } catch {
            print("EmojiArtDocument: error while saving \(error.localizedDescription)")
        }
    }
    
    private func resize(_ emoji: Emoji, by scale: CGFloat) {
        emojiArt[emoji].size = Int(CGFloat(emojiArt[emoji].size) * scale)
    }
    
    private func move(_ emoji: Emoji, by offset: CGOffset) {
        let existingPosition = emojiArt[emoji].position
        emojiArt[emoji].position = Emoji.Position(
            x: existingPosition.x + Int(offset.width),
            y: existingPosition.y - Int(offset.height)
        )
    }
    
    // MARK: - Intent(s)

    func setBackground(_ url: URL?) {
        emojiArt.setBackground(url)
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }
    
    func removeEmoji(_ emoji: Emoji) {
        emojiArt.removeEmoji(emoji)
    }
    
    func move(emojiWithId id: Emoji.ID, by offset: CGOffset) {
        if let emoji = emojiArt[id] {
            move(emoji, by: offset)
        }
    }
    
    func resize(emojiWithId id: Emoji.ID, by scale: CGFloat) {
        if let emoji = emojiArt[id] {
            resize(emoji, by: scale)
        }
    }
}

extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}
