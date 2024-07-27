//
//  EmojiArtDocumentView.swift
//  Emoji Art
//
//  Created by zhira on 7/23/24.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    @ObservedObject var document: EmojiArtDocument

    private let paletteEmojiSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    @GestureState private var zoomGestureState: CGFloat = 1
    @GestureState private var panGestureState: CGOffset = .zero

    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                zoomGestureContents(in: geometry)
                    .scaleEffect(zoom * zoomGestureState)
                    .offset(pan + panGestureState)
            }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: StrurlData.self) { sturldatas, location in
                drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($zoomGestureState) { value, zoomGestureState, _ in
                zoomGestureState = value
            }
            .onEnded { value in
                zoom *= value
            }
    }
    
    private var panGesture: some Gesture {
        DragGesture()
            .updating($panGestureState) { value, panGestureState, _ in
                panGestureState = value.translation
            }
            .onEnded { value in
                pan += value.translation
            }
    }
    
    @ViewBuilder
    private func zoomGestureContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.content)
                .font(emoji.font)
                .position(emoji.position.in(geometry))
        }
    }

    private func drop(_ sturldatas: [StrurlData], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(
                    emoji,
                    at: emojiPosition(at: location, in: geometry),
                    size: paletteEmojiSize / zoom
                )
                return true
            default:
                break
            }
        }
        return false
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(
            x: Int((location.x - center.x - pan.width) / zoom),
            y: Int((center.y - location.y + pan.height) / zoom)
        )
    }
}

#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
}
