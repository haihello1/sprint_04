//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Daniil on 04.05.2025.
//

import UIKit

final class AlertPresenter {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func presentAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
