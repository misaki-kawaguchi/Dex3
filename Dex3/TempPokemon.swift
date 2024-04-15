//
//  TempPokemon.swift
//  Dex3
//
//  Created by 川口美咲 on 2024/04/16.
//

import Foundation

struct TempPokemon: Codable {
    let id: Int
    let Name: String
    let types: [String]
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int
    let specialDefense: Int
    let speed: Int
    let sprite: URL
    let shiny: URL
}
