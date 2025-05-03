//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Daniil on 03.05.2025.
//

import Foundation
// s
protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
//mem
