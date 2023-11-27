//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by LERÄ on 14.11.23.
//

import XCTest //импорт фреймворк для тестирования
@testable import MovieQuiz // импорт приложения для тестирования

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: false) // говорим, что не хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        //When
        //функция загрузки фильмов - асинхронная, делаем ожидание
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies {result in
            //Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                // мы не ожидаем, что пришла ошибка; если она появится надо будет провалить тест
                XCTFail("Unexpected failure") // функция провала теста
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        //When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            //Then
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
}
