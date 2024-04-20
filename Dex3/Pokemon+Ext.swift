//
//  Pokemon+Ext.swift
//  Dex3
//
//  Created by 川口美咲 on 2024/04/20.
//

import Foundation

extension Pokemon {
    var background: String {
        switch self.types![0] {
        case "normal", "grass", "poison", "fairy":
            return "normalgrasselectricpoisonfairy"
        case "rock", "ground", "steel", "fighting", "ghost", "datk", "psychic":
            return "rockgroundsteelfightingghostdarkpsychic"
        case "fire", "dragon":
            return "firedragon"
        case "flying", "bug":
            return "flyingbug"
        case "ico":
            return "ico"
        case "water":
            return "water"
        default:
            return "hi"
        }
    }
}
