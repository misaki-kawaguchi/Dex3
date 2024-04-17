//
//  FetchController.swift
//  Dex3
//
//  Created by 川口美咲 on 2024/04/17.
//

import Foundation

struct FetchController {
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    func fetchAllPokemon() async throws -> [TempPokemon] {
        var allPokemon: [TempPokemon] = []
        
        // パスにクエリパラメータを追加
        var fetchComponents  = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "386")]
        
        // fetchURLが正しく生成されたことを確認
        guard let fetchURL = fetchComponents?.url else {
            // 失敗したらbadURLエラーを投げる
            throw NetworkError.badURL
        }
        
        // APIからデータを非同期に取得し、そのレスポンスを検証
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // ステータスコードが200以外の場合はbadResponseエラーを投げる
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        // dataをJSONデータ→Foundationオブジェクトに変換する。取得したオブジェクトを[String: Any]型にキャスト。失敗するとnilが返される。
        // pokeDictionnaryからキーが"result"の値を取り出し、それを[[String: String]]型にキャストする。
        // いずれかが失敗すれば、NetworkError.badDataエラーがスローされる。
        guard let pokeDictionnary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokedex = pokeDictionnary["result"] as? [[String: String]] else {
            throw NetworkError.badData
        }
        
        for pokemon in pokedex {
            // pokemon["url"]を取得しfetcuPokemonしたレスポンスをallPokemonに追加する
            if let url = pokemon["url"] {
                allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
            }
        }
        
        return allPokemon
    }
    
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        
        print("fetch \(tempPokemon.id)： \(tempPokemon.name)")
        
        return tempPokemon
    }
}
