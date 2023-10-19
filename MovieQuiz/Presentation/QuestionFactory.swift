//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by LERÄ on 11.09.23.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {

    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    private var movies: [MostPopularMovie] = []
    
    func loadData () {
        moviesLoader.loadMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let mostPopularMovies):
                self.movies = mostPopularMovies.item
                self.delegate?.didLoadDataFromServer()
            case .failure(let error):
                self.delegate?.didFailToLoadData(with: error)
            }
        }
    }
    func requestNextQuestion() {}
}
   // private let questions: [QuizQuestion] = [
        //QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        //QuizQuestion(image: "Kill Bill",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        //QuizQuestion(image: "The Avengers",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        //QuizQuestion(image: "Deadpool",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        //QuizQuestion(image: "The Green Knight",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        //QuizQuestion(image: "Old",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: false),
        //QuizQuestion( image: "The Ice Age Adventures of Buck Wild",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: false),
        //QuizQuestion(image: "Tesla",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: false),
        //QuizQuestion(image: "Vivarium",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: false)]
    
    // func requestNextQuestion() { guard let index = (0..<questions.count).randomElement() else { delegate?.didReceiveNextQuestion(question: nil) return }

        //let question = questions[safe: index] delegate?.didReceiveNextQuestion(question: question)}

