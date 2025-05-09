import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?

    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol?
    
    // Делает из вопроса, выдаваемого фабрикой, вопрос для показа на экране
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    // Берет вопрос, меняет на экране изображение, вопрос, номер вопроса
    private func show(quiz step: QuizStepViewModel) {
        cinemaImage.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    // Формирует модеоль AlertModel, отправляет в AlertPresenter для показа алерта
    func makeAlert(quiz result: QuizResultsViewModel) {
        let model = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.presentAlert(model: model)
    }
    
    // Если последний вопрос - вызывает makeAlert
    // Если не последний - увеличивает счетчик, запрашивает новый вопрос
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            let result = GameResult(correctAnswersNumber: correctAnswers, questionsNumber: questionsAmount, currentDate: Date())
            statisticService.store(result: result)
            let text: String =
                """
                Ваш результат \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(statisticService.totalGamesNumber)
                Рекорд: \(statisticService.bestGame)
                Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy * 100)) %
                """
            makeAlert(
                quiz: QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: text,
                    buttonText: "Сыграть ещё раз"
                )
            )
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    // Создает обводку, блокирует кнопки, проверяет правильность
    // Вызывает следующий вопрос
    private func showAnswerResult(isCorrect: Bool) {
        cinemaImage.layer.masksToBounds = true
        cinemaImage.layer.borderWidth = 8
        cinemaImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        if isCorrect {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.cinemaImage.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    
    @IBOutlet private weak var cinemaImage: UIImageView!
    
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        alertPresenter = AlertPresenter(viewController: self)
        
        statisticService = StatisticService()
        
        cinemaImage.layer.cornerRadius = 20
        noButton.layer.cornerRadius = 15
        yesButton.layer.cornerRadius = 15
    }

    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    // Принимает вопрос от генератора, обновляет UI в главном потоке
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
}
