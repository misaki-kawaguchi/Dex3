//
//  SamplePokemon.swift
//  Dex3
//
//  Created by 川口美咲 on 2024/04/20.
//

import Foundation
import CoreData

struct SamplePokemon {
    static let samplePokemon = {
        // CoreDataのコンテキストを取得
        let context = PersistenceController.preview.container.viewContext
        
        // Pokemonエンティティから取得（フェッチするレコード数を1つに限定）
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        // fetchRequestを実行しresultsに格納
        let results = try! context.fetch(fetchRequest)
        
        return results.first!
    }()
}
