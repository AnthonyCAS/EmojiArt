//
//  EmojiArt.swift
//  Emoji Art
//
//  Created by zhira on 7/23/24.
//

import Foundation

struct EmojiArt: Codable {
    private(set) var background: URL?
    
    private(set) var emojis = [Emoji]()
    
    private var uniqueEmojiId: Int = 0
    
    mutating func setBackground(_ url: URL?) {
        background = url
    }
    
    init() {}
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(EmojiArt.self, from: json)
    }
    
    func json() throws -> Data {
        let enconded = try JSONEncoder().encode(self)
        print("EmojiArt: \(String(data: enconded, encoding: .utf8) ?? "nil")")
        return enconded
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
        guard let index = index(of: emojiId) else {
            return nil
        }
        return emojis[index]
    }

    subscript(_ emoji: Emoji) -> Emoji {
        get {
            guard let index = index(of: emoji.id) else {
                return emoji
            }
            return emojis[index]
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
    
    struct Emoji: Identifiable, Codable {
        let content: String
        var position: Position
        var size: Int
        let id: Int
        
        struct Position: Codable {
            let x: Int
            let y: Int
            
            static let zero = Self(x: 0, y: 0)
        }
    }
}
