//
//  ItemDetail.swift
//  Excercise03SwiftUI
//
//  Created by Dev on 15/01/2024.
//

import SwiftUI

struct ItemDetail: View {
    let item: Item

    var body: some View {
        VStack {
            Text(item.name)
                .font(.title)
            Text(item.description)
                .padding()
        }
        .navigationTitle("Item Detail")
    }
}

