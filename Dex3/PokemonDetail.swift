//
//  PokemonDetail.swift
//  Dex3
//
//  Created by 川口美咲 on 2024/04/20.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
    // データをビューの階層内のどの場所からでもアクセスできる
    @EnvironmentObject var pokemon: Pokemon
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PokemonDetail()
        .environmentObject(SamplePokemon.samplePokemon)
}
