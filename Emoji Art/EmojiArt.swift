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
