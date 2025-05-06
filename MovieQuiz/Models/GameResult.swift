//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Daniil on 05.05.2025.
//

import Foundation

// Результат игры, формируется в конце каждой игры
struct GameResult: Codable {
    let correctAnswersNumber: Int
    let questionsNumber: Int
    let currentDate: Date

    // метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        correctAnswersNumber > another.correctAnswersNumber
    }
}
