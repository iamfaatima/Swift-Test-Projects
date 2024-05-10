//
//  ContentView.swift
//  Excercise03SwiftUI
//
//  Created by Dev on 15/01/2024.
//


import SwiftUI

struct ContentView: View {
    let items: [Item] = [
        Item(id: 1, name: "Item 1", description: "Description for Item 1"),
        Item(id: 2, name: "Item 2", description: "Description for Item 2"),
        Item(id: 3, name: "Item 3", description: "Description for Item 3")
    ]

    var body: some View {
        NavigationView {
            List(items, id: \.id) { item in
                NavigationLink(destination: ItemDetail(item: item)) {
                    Text(item.name)
                }
            }
            .navigationTitle("Items")
        }
    }
}

// ContentView.swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
