//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Daniil on 05.05.2025.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalGamesNumber: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }

    func store(result: GameResult)
}
