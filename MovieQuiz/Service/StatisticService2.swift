//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Daniil on 05.05.2025.
//
//
//import Foundation
//
//struct GameRecord: Codable {
//    let correct: Int
//    let total: Int
//    let date: Date
//}
//
//protocol StatisticService {
//    func store(correct count: Int, total amount: Int)
//    var totalAccuracy: Double { get }
//    var gamesCount: Int { get }
//    var bestGame: GameRecord { get }
//}
//
//final class StatisticServiceImplementation: StatisticService {
//    private let userDefaults = UserDefaults.standard
//
//    private enum Keys {
//        static let correct = "correct"
//        static let total = "total"
//        static let gamesCount = "gamesCount"
//        static let bestGame = "bestGame"
//    }
//
//    var totalAccuracy: Double {
//        let correct = userDefaults.integer(forKey: Keys.correct)
//        let total = userDefaults.integer(forKey: Keys.total)
//        return total == 0 ? 0 : Double(correct) / Double(total) * 100
//    }
//
//    var gamesCount: Int {
//        get { userDefaults.integer(forKey: Keys.gamesCount) }
//        set { userDefaults.set(newValue, forKey: Keys.gamesCount) }
//    }
//
//    var bestGame: GameRecord {
//        get {
//            guard let data = userDefaults.data(forKey: Keys.bestGame),
//                  let game = try? JSONDecoder().decode(GameRecord.self, from: data) else {
//                return GameRecord(correct: 0, total: 0, date: Date())
//            }
//            return game
//        }
//        set {
//            guard let data = try? JSONEncoder().encode(newValue) else { return }
//            userDefaults.set(data, forKey: Keys.bestGame)
//        }
//    }
//
//    func store(correct count: Int, total amount: Int) {
//        let currentRecord = GameRecord(correct: count, total: amount, date: Date())
//        
//        // обновляем количество игр
//        gamesCount += 1
//
//        // сохраняем общую статистику
//        let totalCorrect = userDefaults.integer(forKey: Keys.correct) + count
//        let totalQuestions = userDefaults.integer(forKey: Keys.total) + amount
//        userDefaults.set(totalCorrect, forKey: Keys.correct)
//        userDefaults.set(totalQuestions, forKey: Keys.total)
//
//        // обновляем лучшую игру
//        if currentRecord.correct > bestGame.correct {
//            bestGame = currentRecord
//        }
//    }
//}
//
