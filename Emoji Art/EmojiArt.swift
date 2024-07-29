//
//  EmojiArt.swift
//  Emoji Art
//
//  Created by zhira on 7/23/24.
//

import Foundation

struct EmojiArt {
    private(set) var background: URL?
    
    private(set) var emojis = [Emoji]()
    
    private var uniqueEmojiId: Int = 0
    
    mutating func setBackground(_ url: URL?) {
        background = url
    }
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiId += 1
        emojis.append(
            Emoji(
                content: emoji,
                position: position,
                size: size,
                id: uniqueEmojiId
            )
        )
    }
    
    mutating func removeEmoji(_ emoji: Emoji) {
        if let index = emojis.firstIndex(where: { $0.id == emoji.id }) {
            emojis.remove(at: index)
        }
    }
    
    subscript(_ emojiId: Emoji.ID) -> Emoji? {
        if let index = index(of: emojiId) {
            return emojis[index]
        } else {
            return nil
        }
    }

    subscript(_ emoji: Emoji) -> Emoji {
        get {
            if let index = index(of: emoji.id) {
                return emojis[index]
            } else {
                return emoji // should probably throw error
            }
        }
        set {
            if let index = index(of: emoji.id) {
                emojis[index] = newValue
            }
        }
    }
    
    private func index(of emojiId: Emoji.ID) -> Int? {
        emojis.firstIndex(where: { $0.id == emojiId })
    }
    
    struct Emoji: Identifiable {
        let content: String
        var position: Position
        var size: Int
        let id: Int
        
        struct Position {
            let x: Int
            let y: Int
            
            static let zero = Self(x: 0, y: 0)
        }
    }
}
