//
//  FetchController.swift
//  Dex3
//
//  Created by 川口美咲 on 2024/04/17.
//

import Foundation
import CoreData

struct FetchController {
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    func fetchAllPokemon() async throws -> [TempPokemon]? {
        if havePokemon() {
            return nil
        }
        
        var allPokemon: [TempPokemon] = []
        
        // パスにクエリパラメータを追加
        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
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
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let pokedex = pokeDictionary["results"] as? [[String: Any]] else {
            print("bad data")
            throw NetworkError.badData
        }
        
        for pokemon in pokedex {
            // pokemon["url"]を取得しfetcuPokemonしたレスポンスをallPokemonに追加する
            if let url = pokemon["url"] as? String {
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
        
        do {
            let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
            print("fetch \(tempPokemon.id)： \(tempPokemon.name)")
            return tempPokemon
        } catch {
            print("JSON Decoding Error: \(error)")
            throw NetworkError.badData
        }
    }
    
    // 特定のポケモンがすでにアプリケーションのデータベースに存在するかどうかをチェックするためのメソッド
    private func havePokemon() -> Bool {
        // バックグラウンドでのデータ操作用コンテキストの生成
        let context = PersistenceController.shared.container.newBackgroundContext()
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        // データベースから特定の条件に合致するデータのみ抽出する。
        // idが1または386のエンティティのみを抽出する。
        fetchRequest.predicate = NSPredicate(format: "id IN %@", [1, 386])
        
        do {
            let checkPokemon = try context.fetch(fetchRequest)
            
            // idが1と386のエンティティを取得した場合
            if checkPokemon.count == 2 {
                return true
            }
        } catch {
            print("Fetch failed: \(error)")
            return false
        }
        
        return false
    }
}
