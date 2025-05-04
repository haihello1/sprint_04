//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Daniil on 03.05.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    
    func didReceiveNextQuestion(question: QuizQuestion?)
    
}
