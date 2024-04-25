//
//  TempPokemon.swift
//  Dex3
//
//  Created by 川口美咲 on 2024/04/16.
//

import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
    var hp = 0
    var attack = 0
    var defense = 0
    var specialAttack = 0
    var specialDefense = 0
    var speed =  0
    let sprite: URL
    let shiny: URL
    
    // EncodeとDecodeでキー名が異なる時に一対一対応させる
    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatDictionarykeys: String, CodingKey {
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    init(from decoder: Decoder) throws {
        // デコーダーからキーによって区切られたコンテナを取得
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        // *[id]：取得したコンテナからidキーに対応する値を読み取り、それをInt型としてデコードする
        id = try container.decode(Int.self, forKey: .id)
        // *[name]：取得したコンテナからnameキーに対応する値を読み取り、それをString型としてデコードする
        name = try container.decode(String.self, forKey: .name)
        
        // *[types]
        var decodesTypes: [String] = []
        // typesキーの配列をアンキードコンテナとして読み込む
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        
        // アンキードコンテナが終わるまでループを続け各要素を処理する
        while !typesContainer.isAtEnd {
            // 各要素を一つずつ処理して、その中のtypeキーにアクセスする
            let typesDictionnaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionnaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            
            // typesDictionnaryContainerからnameキーに基づいてタイプ名がデコードされる
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodesTypes.append(type)
        }
        types = decodesTypes
        
        // *[stats]
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionarykeys.self)
            let statsContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionarykeys.StatKeys.self, forKey: .stat)
            
            switch try statsContainer.decode(String.self, forKey: .name) {
            case "hp":
                hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
                
            case "attack":
                attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
                
            case "defense":
                defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
                
            case "special-attack":
                specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
                
            case "special-defense":
                specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
                
                
            default:
                print("It will never get here so...")
            }
        }
        
        // *[sprites]
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
        
    }
}
