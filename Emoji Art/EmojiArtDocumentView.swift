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

    @State private var selectedEmojis = Set<EmojiArt.Emoji.ID>()

    private let paletteEmojiSize: CGFloat = 40
    private let selectedEmojiSize: CGFloat = 60
    
    private func isSelected(_ emoji: Emoji) -> Bool {
        selectedEmojis.contains(emoji.id)
    }

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
                documentContents(in: geometry)
                    .scaleEffect(zoom * zoomGestureState)
                    .offset(pan + panGestureState)
            }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: StrurlData.self) { sturldatas, location in
                drop(sturldatas, at: location, in: geometry)
            }
            .onTapGesture {
                selectedEmojis.removeAll()
            }
        }
    }

    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($zoomGestureState) { inMotionPinchScale, zoomGestureState, _ in
                zoomGestureState = inMotionPinchScale
            }
            .onEnded { endingPinchScale in
                zoom *= endingPinchScale
            }
    }

    private var panGesture: some Gesture {
        DragGesture()
            .updating($panGestureState) { inMotionDragGestureValue, panGestureState, _ in
                panGestureState = inMotionDragGestureValue.translation
            }
            .onEnded { endingDragGestureValue in
                pan += endingDragGestureValue.translation
            }
    }

    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.content)
                .font(emoji.font)
                .overlay {
                    SelectedShape(enabled: isSelected(emoji))                    
                        .frame(width: selectedEmojiSize, height: selectedEmojiSize)
                }
                .position(emoji.position.in(geometry))
                .onTapGesture {
                    tapEmoji(emoji)
                }
        }
    }
    
    private func tapEmoji(_ emoji: Emoji) {
        withAnimation {
            if isSelected(emoji) {
                selectedEmojis.remove(emoji.id)
            } else {
                selectedEmojis.insert(emoji.id)
            }
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
