//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Daniil on 04.05.2025.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
