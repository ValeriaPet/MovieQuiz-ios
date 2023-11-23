import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    private let presenter = MovieQuizPresenter()
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService = StatisticServiceImplementation()
    
    
    // MARK: - QuestionFactoryDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(),delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
        alertPresenter = ResultAlertPresenter(viewController: self)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError (message: String) {
        let model = AlertModel (
            title: "Ошибка",
            message: message,
            textButton: "Попробовать еще раз") { [weak self] in
                guard let self = self else {return}
                
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        alertPresenter?.show(alertModel: model)
    }
    
    func show(quiz step: QuizStepViewModel) {
        // сброс стиля рамки
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    func show(quiz result: QuizResultsViewModel) {
        statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
        let alert = UIAlertController(
            title: "Результат квиза",
            message: """
Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
Количество сыграных квизов: \(statisticService.gamesCount)
Рекорд: \(statisticService.bestGame.correct)/\(presenter.questionsAmount)(\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
""", preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Alert"
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.presenter.resetQuestionIndex()// 1
            self.correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func showAnswerResult(isCorrect: Bool){
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        if isCorrect == true {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor // делаем рамку зеленой
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor // делаем рамку красной
        }
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            let text = correctAnswers == presenter.questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel( // 2
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel) // 3
            
        } else { // 2
            presenter.switchToNextQuestion()
            // идём в состояние "Вопрос показан"
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
