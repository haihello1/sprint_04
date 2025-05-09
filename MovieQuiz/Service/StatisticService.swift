//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Daniil on 06.05.2025.
//

import Foundation


final class StatisticService: StatisticServiceProtocol {
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let totalCorrectAnswersNumber = "totalCorrectAnswersNumber"
        static let totalQuestionsNumber = "totalQuestionsNumber"
        static let totalGamesNumber = "totalGamesNumber"
        static let bestGame = "bestGame"
    }
    
    // MARK: - Computed properties for Controller
    
    private(set) var totalGamesNumber: Int {
        get {
            return userDefaults.integer(forKey: Keys.totalGamesNumber)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalGamesNumber)
        }
    }
    
    private(set) var bestGame: GameResult {
        get {
            if let data = userDefaults.data(forKey: Keys.bestGame),
               let result = try? JSONDecoder().decode(GameResult.self, from: data) {
                return result
            }
            return GameResult(correctAnswersNumber: 0, questionsNumber: 0, currentDate: Date())
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            userDefaults.set(data, forKey: Keys.bestGame)
        }
    }
    
    var totalAccuracy: Double {
        if totalQuestionsNumber == 0 { return 0.0 }
        return Double(totalCorrectAnswersNumber) / Double(totalQuestionsNumber)
    }
    
    // MARK: - Inner computed properties
    
    private var totalCorrectAnswersNumber: Int {
        get {
            return userDefaults.integer(forKey: Keys.totalCorrectAnswersNumber)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalCorrectAnswersNumber)
        }
    }
    
    private var totalQuestionsNumber: Int {
        get {
            return userDefaults.integer(forKey: Keys.totalQuestionsNumber)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalQuestionsNumber)
        }
    }
    
    func store(result: GameResult) {
        totalGamesNumber += 1
        totalCorrectAnswersNumber += result.correctAnswersNumber
        totalQuestionsNumber += result.questionsNumber
        if result.isBetterThan(bestGame) {
            bestGame = result
        }
    }
}
