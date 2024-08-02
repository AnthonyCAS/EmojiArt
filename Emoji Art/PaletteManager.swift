//
//  PaletteManager.swift
//  Emoji Art
//
//  Created by zhira on 7/31/24.
//

import SwiftUI

struct PaletteManager: View {
    let stores: [PaletteStore]
    
    @State private var selectedStore: PaletteStore?
    var body: some View {
        NavigationSplitView {
            List(stores, selection: $selectedStore) { store in
                Text(store.name)
                    .tag(store)
                PaletteStoreView(store: store)
            }
        } content: {
            if let selectedStore {
                EditablePaletteList(store: selectedStore)
            }
            Text("Choose a Store")
        } detail: {
            
            Text("Choose a Palette")
        }
    }
}

struct PaletteStoreView: View {
    @ObservedObject var store: PaletteStore
    
    var body: some View {
        Text(store.name)
    }
}

#Preview {
    PaletteManager(stores: [PaletteStore(name: "Preview1"), PaletteStore(name: "Preview2")])
}
