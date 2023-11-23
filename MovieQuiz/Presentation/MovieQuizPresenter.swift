//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by LERÄ on 21.11.23.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewController?
    

    private func didAnswer(isYes:Bool) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    func yesButtonClicked() {
        didAnswer(isYes:true)
    }
    func noButtonClicked() {
        didAnswer(isYes:false)
    }

    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    func switchToNextQuestion() {
         currentQuestionIndex += 1
     }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel( // 2
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel) // 3
            
        } else { // 2
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
          QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
